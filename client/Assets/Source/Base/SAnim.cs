using UnityEngine;
using System.Collections;

public class SAnim : MonoBehaviour {

    public enum TType
    {
        pos
    }

    public TType    type;
    public Vector3 param;


	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
        switch (type)
        {
            case TType.pos:
                transform.position += param * Time.deltaTime;
                break;
        }
	}
}
