require Tools

defmodule AowTest do
  use ExUnit.Case
  doctest Aow

  test "the truth" do
    assert 1 + 1 == 2
  end


  test "proto" do
  	
  	proto = Proto.load_proto("../config/proto.txt")

	data = %{
		key: "123",
		index: 1,
		array: [1,2,3,4],
		datas: ["a"]
	}
	params = [data,"test",[1,2,3],12.3,false] 

	org_term = %{class: "test", fun: "login", params: params}

	bin = Proto.term_to_bin(proto,org_term)
	Tools.log(bin)
	term = Proto.bin_to_term(proto,bin)

	Tools.log(term)


	assert(  org_term == term )
  end

end
