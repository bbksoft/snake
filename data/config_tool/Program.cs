using System;
using System.IO;
using Excel;
using System.Data;
using System.Collections.Generic;

namespace export
{

	class TableData{
		public string name;
		public List<string[]> datas = new List<string[]>();

		public void Add(string[] data)
		{
			datas.Add (data);
		}

		public void SetName(string value)
		{
			name = Path.GetFileNameWithoutExtension(value);

		}
	}

	class MainClass
	{
		public static void Main (string[] args)
		{
			string curPath = System.IO.Directory.GetCurrentDirectory ();

			while(curPath.IndexOf("config") > 0){			
				System.IO.Directory.SetCurrentDirectory ("..");
				curPath = System.IO.Directory.GetCurrentDirectory ();
			}

			Console.WriteLine ("current directory:" + curPath);			

			
			// search files in dir
			string[] files = System.IO.Directory.GetFiles(".", "*.xlsx", System.IO.SearchOption.AllDirectories);	


			List<TableData> dataTables = new List<TableData>();

			foreach (string file in files) {
				Console.WriteLine ("load file:" + file);			


				FileStream stream = File.Open(file, FileMode.Open, FileAccess.Read);

				IExcelDataReader excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
							
				if (excelReader.IsValid) {

					do {
						TableData td = new TableData ();
						td.SetName (excelReader.Name);
						while (excelReader.Read ()) {
					
							string[] datas = new string[excelReader.FieldCount];

							for (int i = 0; i < excelReader.FieldCount; i++) {
								datas [i] = excelReader.GetString (i);
							}
							td.Add (datas);

						}

                        if (td.datas!=null & td.datas.Count>=3)
                        {
                            dataTables.Add(td);
                        }
						
					} while(excelReader.NextResult ());
				}

				excelReader.Close();

			}

			WirteToLua (dataTables);
            WirteToServer(dataTables);

            Console.WriteLine("export ok.");
            Console.Read();
        }

		static void WirteToLua(List<TableData> dataTables)
		{
			List<string> datas = new List<string> ();

			foreach(TableData t in dataTables)
			{
				datas.Add ("cfg_"+t.name+" = {");

				string[] names = t.datas [0];
				string[] types = t.datas [1];

                string lastKey = "";
				for (int i = 2; i<t.datas.Count; i++) {
					
					string[] values = t.datas [i];

                    if (values[0] == "" || values[0]==null)
                    {
                        break;
                    }

                    string head = "\t";
					int start_index = 1;
					if (types [1] == "key") {
						start_index = 2;
                        head = "\t\t";
                        if (lastKey != values[0])
                        {
                            if (lastKey != "")
                            {
                                datas.Add( "\t},");
                            }
                            datas.Add("\t[" + values[0] + "] =  {");
                        }
                        lastKey = values[0];
                        datas.Add("\t\t[" + values[1] + "] =  {");                        
					} else {
                        datas.Add("\t[" + values[0] + "] =  {");
                    }

					for(int j=start_index; j<values.Length; j++)
					{
						switch (types [j]) {
                        case "list":
                            string temp = "";
                            if (values[j] != null)
                            {
                                temp = values[j].Replace(';', ',');
                            }
                            datas.Add(head + "\t" + names[j] + "={" + temp + "},");
                            break;
                        case "number":
							datas.Add (head + "\t" + names [j] + "=" + values [j] + ",");
							break;
						case "string":
							datas.Add (head + "\t" + names [j] + "=\"" + values [j] + "\",");
							break;
                        case "bool":
                            if ( (values[j] == "true") || (values[j] == "True"))
                            {
                                values[j] = "true";
                            }
                            else
                            {
                                 values[j] = "false";
                            }
                            datas.Add(head + "\t" + names[j] + "=" + values[j] + ",");
                            break;
                        case "enum":
                            datas.Add(head + "\t" + names[j] + "=\"" + values[j] + "\",");
                            break;
                        default:
                            datas.Add(head+"\t" + names[j] + "=" + values[j] + ",");
                            break;
						}
					}

					datas.Add(head + "},");
				}
                if (lastKey != "")
                {
                    datas.Add("\t},");
                }

                datas.Add("}");

			}

			System.IO.File.WriteAllLines("../client/Assets/Lua/config/exConfig.lua", datas);
			
		}


        static string _str;
        static bool _first;
        static void _AddStrBase(string value)
        {
            if ((_str == null)||(_first))
            {
                if (_str != null)
                {
                    _str += "\n";
                }

                _str += value;
            }
            else
            {               

                _str += ",";
                _str += value;
            }
            _first = false;
        }

        static void _AddStr(int value)
        {
            _first = true;
            _AddStrBase(value.ToString());
        }

        static void _AddStr(string[] values)
        {
            _first = true;
            foreach (string v in values)
            {
                _AddStrBase(v);
            }
        }       

        static void WirteToServer(List<TableData> dataTables)
        {
           

            foreach (TableData t in dataTables)
            {
                _str = null;                

                string[] names = t.datas[0];
                string[] types = t.datas[1];

                _AddStr(names);
                _AddStr(types);
            
                for (int i = 2; i < t.datas.Count; i++)
                {
                    string[] values = t.datas[i];

                    if (values[0] == "" || values[0] == null)
                    {
                        break;
                    }

                    for (int j = 0; j < values.Length; j++)
                    {
                        switch (types[j])
                        {                           
                            case "bool":
                                if ((values[j]=="TRUE")|| (values[j] == "true"))
                                {
                                    values[j] = "true";
                                }
                                else
                                {
                                    values[j] = "false";
                                }
                                break;
                            case "list":
                                string temp = "";
                                if (values[j] != null)
                                {
                                    temp = values[j].Replace(';', ',');
                                }
                                values[j] = "{" + temp + "}";
                                break;
                        }
                    }
                    _AddStr(values);                    
                }               

                System.IO.File.WriteAllText("../server/config/" + t.name + ".cfg", _str);
            }

            _str = "# make by the tool[config]";
            //_str += "\nrequire Record";
            foreach (TableData t in dataTables)
            {

                _str += "\ndefmodule Cfg_" + t.name + " do";
                string[] names = t.datas[0];
                string[] types = t.datas[1];

                //_str += "\n\tRecord.defrecordp :self"; 
                //for (int i = 0; i < names.Length; i++)
                //{
                //    _str += "," + names[i] + ": nil";
                //}

                _str += "\n";
                _str += "\n\tdef get(id) do";
                _str += "\n\t\tCfg.get(:cfg_" + t.name + ",id)";
                _str += "\n\tend";


                _str += "\n";
                _str += "\n\tdef get_field_id(id) do";
                _str += "\n\t\tcase id do";
                for (int i = 0; i < names.Length; i++)
                {                    
                    _str += "\n\t\t\t:" + names[i] + " -> " + i;
                }
                _str += "\n\t\t\t_ -> nil";
                _str += "\n\t\tend";
                _str += "\n\tend";
   

                _str += "\n";
                _str += "\n\tdef match(list) do";
                _str += "\n\t\tq = {";
                for (int i = 0; i < names.Length; i++)
                {
                    if (i != 0) _str += ",";
                    _str += ":\"_\"";
                }
                _str += "}";
                _str += "\n\t\tCfg.match(:cfg_" + t.name + ",list,q,fn(x)-> get_field_id(x) end)";
                _str += "\n\tend";

                _str += "\n";
                _str += "\n\tdef find(list) do";
                _str += "\n\t\tq = {";
                for (int i = 0; i < names.Length; i++)
                {
                    if (i != 0) _str += ",";
                    _str += ":\"$" + (i + 1) + "\"";
                }
                _str += "}";
                _str += "\n\t\tCfg.find(:cfg_" + t.name + ",list,q,fn(x)-> get_field_id(x) end)";
                _str += "\n\tend";


                for (int i = 0; i < names.Length; i++)
                {
                    _str += "\n";
                    _str += "\n\tdef " + names[i] + "(record) when is_tuple(record) do";
                    _str += "\n\t\telem(record," + i + ")";
                    _str += "\n\tend";

                    _str += "\n\tdef " + names[i] + "(id) do";
                    _str += "\n\t\tCfg.get_field(:cfg_" + t.name + ",id," + i + ")";                    
                    _str += "\n\tend";
                }               

                _str += "\nend";
            }

            System.IO.File.WriteAllText("../server/aow/lib/game/config_data.ex",_str);
        }
    }
}
