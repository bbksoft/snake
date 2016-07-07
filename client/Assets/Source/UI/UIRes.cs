using UnityEngine;
using System.Collections;

public class UIRes : MonoBehaviour {

    public Sprite[] data;
    Hashtable dataHs = new Hashtable();

    void Awake()
    {
        for (int i=0;i<data.Length;i++)
        {
            dataHs[data[i].name] = data[i];
        }
    }

    static Hashtable table = new Hashtable();
    
    public static Sprite GetSprite(string type,string name)
    {
        UIRes res = null;
        if (table.ContainsKey(type))
        {
            res = table[type] as UIRes;
        }
        else
        {
            GameObject obj = Resources.Load("UIRes/"+type) as GameObject;
            GameObject gameobj = GameObject.Instantiate(obj);
            res = gameobj.GetComponent<UIRes>();
            table[type] = res;
        }

        return res.dataHs[name] as Sprite;
    }
	
}
