using UnityEngine;
using System.Collections;

public class SAnim : MonoBehaviour {

    public enum Type
    {
        pos,
        scale,
        rotate,
    }

    public Type    type = Type.pos;
    public Vector3  param;
    public AnimationCurve curve;
    public float len = 1;

    private float time = 0;
    private float oldCurverValue;
    
	// Use this for initialization
	void Start () {
        oldCurverValue = 0;          
    }
	
	// Update is called once per frame
	void Update () {
        time += Time.deltaTime;        
        if (time > len)
        {
            Destroy(this);
            return;
        }

        float value = 0;
        if (curve==null)
        {
            value = time;
        }
        
        switch ( type )
        {
            case Type.pos:
                {
                    float x = param.x * Time.deltaTime;
                    float y = param.y * (value - oldCurverValue);
                    transform.localPosition += new Vector3(x, y, 0);
                }
                break;
            case Type.scale:
                {
                    transform.localScale += param * (value - oldCurverValue);
                }
                break;
            case Type.rotate:
                {
                    transform.Rotate( param * (value - oldCurverValue) );
                }
                break;
        }
        oldCurverValue = value;

    }
}
