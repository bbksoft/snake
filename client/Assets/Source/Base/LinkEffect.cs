using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class LinkEffect: MonoBehaviour {

    public GameObject src;
    public GameObject des;

    public float offPos;

    float life;
    float timeValue;
    public void SetLife(float value)
    {
        life = value;
    }

    List<ParticleSystemRenderer> particles;
    float[] base_len;

    // Use this for initialization
    void Start () {
        particles = new List<ParticleSystemRenderer>();
        ParticleSystemRenderer[] s = transform.GetComponentsInChildren<ParticleSystemRenderer>();

       
        for (int i=0; i<s.Length; i++)
        {
            if (s[i].renderMode == ParticleSystemRenderMode.Stretch)
            {
                particles.Add(s[i]);
            }            
        }

        base_len = new float[particles.Count];
        for (int i = 0; i < base_len.Length; i++)
        {
            base_len[i] = particles[i].lengthScale;
        }
    }
	
	// Update is called once per frame
	void Update () {
        Vector3 srcPos = GameAPI.GetPosIn(src, offPos);
        Vector3 desPos = GameAPI.GetPosIn(des, offPos);

        Vector3 dPos = desPos - srcPos;

        transform.position = srcPos;
        transform.forward = dPos;

        float len = dPos.magnitude;

        if (life > 0)
        {
            float inval = 0.1f;

            timeValue += Time.deltaTime;
            if (timeValue >= life)
            {
                GameObject.Destroy(gameObject);
                return;
            }

            if (timeValue > (life - inval) )
            {
                float value = (life - timeValue) / inval;
                float realLen = len * value;
                transform.position += transform.forward * (len-realLen);
                len = realLen;
            }
            else if (timeValue < inval )
            {
                float value = timeValue / inval;
                len = len * value;
            }
        }

        for (int i=0; i< particles.Count; i++)
        {
            particles[i].lengthScale = len * base_len[i];
        }
	}
}
