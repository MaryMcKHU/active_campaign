defmodule ActiveCampaign.Http do
  @moduledoc """
  The HTTP interface for interacting with the Active Campaign API.
  """

  alias ActiveCampaign.Config

  @spec delete(String.t()) :: {:ok, any()} | {:error, any()}
  def delete(url_path) do
    request(:delete, url_path)
  end

  @spec post(String.t(), any()) :: {:ok, any()} | {:error, any()}
  def post(url_path, body) do
    request(:post, url_path, body)
  end

  @spec put(String.t(), any()) :: {:ok, any()} | {:error, any()}
  def put(url_path, body) do
    request(:put, url_path, body)
  end

  @spec get(String.t()) :: {:ok, any()} | {:error, any()}
  def get(url_path) do
    request(:get, url_path)
  end

  defp request(method, url_path, body \\ "") do
    url = build_url(url_path)
    body = encode_body(body)

    method
    |> HTTPoison.request(url, body, headers())
    |> parse_response()
  end

  defp encode_body(body) when is_map(body) do
    Jason.encode!(body)
  end

  defp encode_body(body), do: body

  defp headers do
    ["Api-Token": Config.api_key()]
  end

  defp parse_response({:ok, %{body: body}}) do
    Jason.decode(body)
  end

  defp build_url(url_path) do
    Config.api_url()
    |> URI.merge(url_path)
  end
end
