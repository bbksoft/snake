using UnityEngine;
using System.Collections;

public class Delay : MonoBehaviour {
    
    public float delay = 1.0f;
    public MyFuns.TFun fun;


    // Use this for initialization
    void Start () {
        StartCoroutine(run());
    }

    IEnumerator run()
    {        
        yield return new WaitForSeconds(delay);

        MyFuns.Do(fun,gameObject);
    }
}
