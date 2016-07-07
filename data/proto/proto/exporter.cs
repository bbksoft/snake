using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.IO;
using System.Reflection;

namespace proto
{
    class my_tools
    {
        static public string type_convert(string value)
        {
            string ret = value;
            if (value == "Byte") ret = "Int";
            if (value == "Int8") ret = "Int";
            if (value == "Int16") ret = "Int";
            if (value == "Int32") ret = "Int";
            if (value == "Int64") ret = "Int";

            return ret;
        }        
    }

    class data_type
    {
        private string _name;
        public string name
        {
            get
            {
                return _name;
            }

            set
            {
                _name = my_tools.type_convert(value);                           
            } 
            
        }

        public bool     is_enum;
        public string[] enum_values;  

        public data_def[] menbers;
    }

    class data_def
    {
        private string _type;
        public string type
        {
            get
            {
                return _type;
            }

            set
            {
                _type = my_tools.type_convert(value);               
            }

        }
        public string name;
        public bool   is_array;        
    }

    class data_fun
    {
        public int id;
        public string name;
        public string class_name;

        public data_def[]  param_list;
        public data_def ret;
    }


    class exporter
    {
        static List<data_type> types;
        static List<data_fun> funs;

        static void get_types()
        {
            types = new List<data_type>();


            add_default_type(typeof(string));
            add_default_type(typeof(int));
            add_default_type(typeof(bool));
            add_default_type(typeof(float));

            Assembly assembly = Assembly.GetExecutingAssembly();

            Type[] type_list = assembly.GetTypes();

            foreach (Type type in type_list)
            {
                if (type.Namespace == "proto_def")
                {
                    if (type.IsInterface) continue;


                    data_type d = new data_type();
                    d.name = type.Name;

                    if (type.IsEnum)
                    {
                        d.is_enum = true;

                        d.enum_values = type.GetEnumNames();
                    }
                    else
                    {
                        FieldInfo[] infos = type.GetFields(BindingFlags.NonPublic
                            | BindingFlags.Public
                            | BindingFlags.Instance | BindingFlags.DeclaredOnly);


                        int count = infos.Length;

                        d.menbers = new data_def[count];
                        for (int i = 0; i < infos.Length; i++)
                        {


                            Type menberType = infos[i].FieldType;
                            d.menbers[i] = get_data_def(menberType);


                            d.menbers[i].name = infos[i].Name;

                        }
                    }

                    add_type(d);
                }
            }
        }

        static void add_default_type(Type t)
        {
            data_type d = new data_type();
            d.name = t.Name;

            add_type(d);
        }

        static void add_type(data_type d)
        {
            types.Add(d);

            //Console.WriteLine(d.name);
        }

        static void get_funs()
        {
            funs = new List<data_fun>();

            int base_fun_id = 0;

            Assembly assembly = Assembly.GetExecutingAssembly();

            Type[] type_list = assembly.GetTypes();

            foreach (Type type in type_list)
            {
                if (type.Namespace == "proto_def")
                {
                    if (type.IsInterface == false) continue;


                    MethodInfo[] infos = type.GetMethods();// BindingFlags.DeclaredOnly);

                    foreach (MethodInfo info in infos)
                    {
                        data_fun d = new data_fun();

                        d.name = info.Name;
                        d.class_name = type.Name;


                        ParameterInfo[] ps = info.GetParameters();
                        d.param_list = new data_def[ps.Length];
                        for (int i = 0; i < d.param_list.Length; i++)
                        {
                            d.param_list[i] = get_data_def(ps[i].ParameterType);
                        }

                        d.ret = get_data_def(info.ReturnType);

                        base_fun_id++;
                        d.id = base_fun_id;

                        funs.Add(d);
                    }
                }
            }
        }

        static data_def get_data_def(Type t)
        {
            data_def ret = new data_def();

            ret.is_array = t.IsArray;

            if (t.IsArray)
            {
                string str = t.Name;
                ret.type = str.Substring(0, str.Length - 2);
            }
            else
            {
                ret.type = t.Name;
            }

            return ret;
        }

        public static void init()
        {
            get_types();
            get_funs();
        }

        public static void do_export(string file)
        {

            string output = "{\"types\":" + JsonConvert.SerializeObject(types.ToArray());
            output += ",\"funs\":" + JsonConvert.SerializeObject(funs.ToArray()) + "}";

            FileStream fs = new FileStream(file, FileMode.Create);
            StreamWriter sw = new StreamWriter(fs);
            sw.Write(output);
            sw.Flush();
            sw.Close();
            fs.Close();
        }

        public static void do_export_lua(string file)
        {
            string output = "-- export by tool[proto]";
            output += "\nlocal ret = {";
            output += "\n\ttypes = {";
            foreach (data_type type in types)
            {
                output += "\n\t\t{";
                output += "\n\t\t\tname=\"" + type.name + "\",";
                if (type.is_enum)
                {
                    output += "\n\t\t\tis_enum=true,";
                    output += "\n\t\t\tenum_values = {";
                    foreach (string str in type.enum_values)
                    {
                        output += "\"" + str + "\",";
                    }
                    output += "},";
                }
                else
                {
                    //output += "\n\t\t\tis_enum=false,";
                }

                output += "\n\t\t\tmenbers = {";
                if (type.menbers != null)
                {
                    
                    foreach (data_def df in type.menbers)
                    {
                        output += get_data_def_string("\t\t\t\t", df);
                        output += ",";
                    }                   
                }
                output += "\n\t\t\t},";

                output += "\n\t\t},";
            }
            output += "\n\t},";

            output += "\n\tfuns = {";
            foreach (data_fun fun in funs)
            {
                output += "\n\t\t{";
                output += "\n\t\t\tid=" + fun.id + ",";
                output += "\n\t\t\tname=\"" + fun.name + "\",";
                output += "\n\t\t\tclass_name=\"" + fun.class_name + "\",";

                output += "\n\t\t\tparam_list = {";

                foreach (data_def df in fun.param_list)
                {
                    output += get_data_def_string("\t\t\t\t", df);
                    output += ",";
                }

                output += "\n\t\t\t},";

                output += "\n\t\t\tret = ";
                output += get_data_def_string("\t\t\t\t", fun.ret);
                output += ",";

                output += "\n\t\t},";
            }
            output += "\n\t}";
            output += "\n}";

            output += "\nreturn ret";

            FileStream fs = new FileStream(file, FileMode.Create);
            StreamWriter sw = new StreamWriter(fs);
            sw.Write(output);
            sw.Flush();
            sw.Close();
            fs.Close();
        }

        static string get_data_def_string(string head, data_def df)
        {
            string str = "\n" + head + "{";

            if ((df.name != null) && (df.name != ""))
            {
                str += "\n" + head + "\tname = \"" + df.name + "\",";
            }
            str += "\n" + head + "\ttype = \"" + df.type + "\",";

            if (df.is_array )
            {
                str += "\n" + head + "\tis_array = true,";
            }

            str += "\n" + head + "}";

            return str;
        }
    }
}
