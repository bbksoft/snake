using UnityEngine;
using System.Collections;

public class FllowObj : MonoBehaviour {

    public GameObject obj;


	// Use this for initialization
	void Start () {
        
	}
	
	// Update is called once per frame
	void Update () {
	    if ( obj )
        {
            UITools.SetToObjTop(obj, transform);           
        }
        else
        {
            GameObject.Destroy(obj);
        }
	}
}
