using System.Collections;
using UnityEngine;

public class SoundPlayer : MonoBehaviour {

    public string   res;
    public float    delay = 0;
    public bool     isMusic;

	// Use this for initialization
	void Start () {
        if (isMusic)
        {
            SoundAPI.PlayMusic(res, delay);
        }
        else
        {
            SoundAPI.PlaySound(res, delay);
        }
    }   

}
