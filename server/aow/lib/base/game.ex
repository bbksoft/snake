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

    def init({socket,mods}) do
		state = %{class: :game, actors: %{}, pionts: %{} }
		state = add_mod(state,mods)
		{:ok, state}
	end

    defp new_actor()
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
        state = %{state | max_id: max_id + 1, actors: %actors{max_id->actor} }
		{:reply,%{user | gameInfo: %{id=max_id,gamePid=self()}}, state}
	end

	def handle_cast({:turn,user,time,dx,dy},state) do

		{:noreply, state}
	end

    def handle_info(:tick,state) do
        state = {state | actor: Enum.map(actors, fn({id,atcor})

        end)
    end

end
