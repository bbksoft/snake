


sound_player = {index=0}


function sound_player.play(name,delay)
    if delay then
        SoundAPI.PlaySound(name,delay)
    else
        SoundAPI.PlaySound(name)
    end

    sound_player.index = sound_player.index + 1
end

function sound_player.one_play(name,inval)
    inval = inval or 0
    local time = sound_player[name] or 0

    if time < Time.time then
        inval = inval + SoundAPI.PlaySound(name)
        sound_player[name] = Time.time + inval
    end
end

function sound_player.play_anim(hero_id,anim)
    local t = cfg_actor_sound[hero_id]
    if t and t[anim] then
        sound_player.play( t[anim].name )
    end
end

function sound_player.play_music(name,delay)
    if delay then
        SoundAPI.PlayMusic(name,delay)
    else
        SoundAPI.PlayMusic(name)
    end
end

function sound_player.stop_all()
    SoundAPI.StopAll()
end
