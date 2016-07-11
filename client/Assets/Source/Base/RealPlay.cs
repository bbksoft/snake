using UnityEngine;
using System.Collections;

public class RealPlay : MonoBehaviour {

    ParticleSystem[] particle;
    ParticleEmitter[] emitter;
    AnimationState animState;
    Animation anim;

    bool pause = false;

    void Start()
    {
        particle = GetComponentsInChildren<ParticleSystem>();
        emitter = GetComponentsInChildren<ParticleEmitter>();
    }

    // Update is called once per frame
    void Update () {

        if (pause) return;

        if (particle!=null)
        {
            for (int i = 0; i < particle.Length; i++)
            {
                if (particle[i]!=null)
                {
                    particle[i].Simulate(Time.unscaledDeltaTime, true, false);
                }
            }
        }
        if (emitter!= null)
        {
            for (int i = 0; i < emitter.Length; i++)
            {
                if (emitter[i] != null)
                {
                    emitter[i].Simulate(Time.unscaledDeltaTime);
                }
            }
        }
        if (animState)
        {
            animState.normalizedTime += Time.unscaledDeltaTime / animState.length;
            anim.Sample();
        }
    }

    public void SetAnim(string name)
    {
        if (anim == null)
        {
            anim = GetComponent<Animation>();
        }

        animState = anim[name];
        if (animState == null)
        {
            Debug.Log("can't found anim:" + name);
            return;
        }

        anim.Play(name);

        animState.normalizedTime = 0;
        anim.Sample();
    }

    public void Pause(bool value)
    {
        pause = value;
    }


}
