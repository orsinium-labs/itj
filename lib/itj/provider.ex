defmodule ITJ.Provider do
  @doc """
  Returns sanitized URL if it is supported by the provider,
  nil otherwise.
  """
  @callback sanitize_url(binary) :: nil | binary

  @doc """
  Synchronize remote offers with the local storage.
  """
  @callback sync(binary) :: pos_integer
end
