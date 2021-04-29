defmodule Pigate.Repo do
  use Ecto.Repo,
    otp_app: :pigate,
    adapter: Ecto.Adapters.Tds
end
