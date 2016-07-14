
using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;

public class SoundAPI : MonoBehaviour
{

    static SoundAPI s;

    static public void Init()
    {
        if (s == null)
        {
            s =  UITools.gCam.gameObject.AddComponent<SoundAPI>();
        }
    }

    static public float PlaySound(string name)
    {
        return PlaySound(name, -1);
    }

    static public float PlaySound(string name,float delay)
    {
        return s.PlayOneShot(name, delay);
    }

    static public void PlayMusic(string name)
    {
        PlayMusic(name, -1);
    }

    static public void PlayMusic(string name,float delay)
    {
        s.Play(name, delay);
    }

    static public void StopAll()
    {
        s.Stop();
    }

    static AudioClip Load(string name)
    {
        return Resources.Load("sound/" + name) as AudioClip;
    }


    AudioSource source;

    void Awake()
    {
        source = gameObject.AddComponent<AudioSource>();
    }

    void Stop()
    {
        StopAllCoroutines();
        source.Stop();
    }

    float PlayOneShot(string name,float delay)
    {
        AudioClip a = Load(name);
        if (delay > 0)
        {
            StartCoroutine(DelayPlay(delay, a));
        }
        else
        {            
            source.PlayOneShot(a);            
        }

        return a.length;
    }

    void Play(string name, float delay)
    {
        AudioClip a = Load(name);

        if (delay > 0)
        {
            source.clip = a;
            source.Play((ulong)(44100 * delay));
        }
        else
        {
            source.clip = a;
            source.Play();
        }
    }

    IEnumerator DelayPlay(float time, AudioClip a)
    {
        yield return new WaitForSeconds(time);

        source.PlayOneShot(a);
    }
}
