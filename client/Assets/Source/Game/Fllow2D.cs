using UnityEngine;
using System.Collections;

public class Fllow2D : MonoBehaviour {

    public GameObject obj;
	
	// Update is called once per frame
	void Update () {
	    if ( obj )
        {
            Vector3 pos = obj.transform.position;
            pos = new Vector3(pos.x, pos.y, transform.localPosition.z);
            transform.localPosition = pos;     
        }
	}
}
