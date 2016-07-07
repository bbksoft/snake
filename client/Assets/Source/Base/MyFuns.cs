using UnityEngine;
using System.Collections;

public class MyFuns
{
    public enum TFun
    {
        DelSelf,
        DelParent
    };

    static public void Do(TFun fun, GameObject gameObject) {
        switch (fun)
        {
            case TFun.DelSelf:
                Object.Destroy(gameObject);
                break;
            case TFun.DelParent:
                Transform t = gameObject.transform;
                while ( t.parent != null)
                {
                    t = t.parent;
                }
                Object.Destroy(t.gameObject);
                break;
        }
    }
}
