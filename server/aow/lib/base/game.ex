require Tools

defmodule Game do

    def snake_enter(user) do
        IO.puts("enter")
        GenServer.call(:g_game,{:enter,user})
    end

    def snake_turn(user,time,dx,dy) do
        GenServer.case(:g_game,{:turn,user,time,dx,dy})
    end

    def start() do
		GenServer.start(__MODULE__,nil,[name: :g_game])
	end

    def init(_) do
		state = %{class: :game, actors: %{}, pionts: %{} }
        send_after(self(), :tick, 100)
		{:ok, state}
	end

    defp new_actor() do
        x = Enum.random(1..100)
        y = Enum.random(1..100)

        %{
            x:          x,
            y:          y,
            len:        1,
            len_tail:   0,
        }
    end

	def handle_call({:enter,user},_from,state) do
        max_id = state.max_id
        actor = new_actor()
        actors = state.actors
        state = %{state | max_id: max_id + 1, actors: %{actors | max_id => actor} }
		{:reply,%{user | gameInfo: %{id: max_id,gamePid: self()}}, state}
	end

	def handle_cast({:turn,user,time,dx,dy},state) do

		{:noreply, state}
	end

    def handle_info(:tick,state) do
        send_after(self(), :tick, 100)

        state = List.foldl(Map.keys(state.actors), state, fn(s,id) ->
            actor_update(s,id)
        end)
    end

    defp actor_update(state,id) do

        actor = state[id]

        coll_pts,new_pts = find_coll_pts(state.points,actor)


        actor = List.foldl(coll_pts, actor, fn(pt) ->
            len_tail = actor.len_tail + 0.2
            %{actor | len_tail: len_tail}
        end)

        if actor.len_tail > 0  do
            actor = %{  actor |
                        len_tail: (actor.len_tail-0.1),
                        len: (actor.len+0.1) }
        end

        if actor_coll(state,actor) do
            boardcast("death",[id])
            %{state | id => nil }
        else
            %{state | id => actor, points: new_pts }
        end
    end

    defp boardcast(cmd,params)
    end

end
