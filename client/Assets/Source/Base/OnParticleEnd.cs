using UnityEngine;
using System.Collections;

public class OnParticleEnd : MonoBehaviour {

    public float delay = 0.0f;
    public MyFuns.TFun fun;

    ParticleSystem particle;

    void Start()
    {
        particle = GetComponent<ParticleSystem>();
    }

   
    void Update()
    {
        if (particle.isStopped)
        {
            StartCoroutine(run());
        }
    }


    IEnumerator run()
    {
        yield return new WaitForSeconds(delay);

        MyFuns.Do(fun, gameObject);
    }
}
