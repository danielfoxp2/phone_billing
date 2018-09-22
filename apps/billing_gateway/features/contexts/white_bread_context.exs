defmodule WhiteBreadContext do
  use WhiteBread.Context

  given_ ~r/^I am doing something$/, fn state ->
    {:ok, state}
  end

  when_ ~r/^I do another thing$/, fn state ->
    {:ok, state}
  end
  
  then_ ~r/^I got my desired outcome$/, fn state ->
    {:ok, state}
  end
end
