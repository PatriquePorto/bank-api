defmodule BananaBank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset

  @require_params [:name, :password_hash, :email, :cep]

  schema "users" do
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :email, :string
    field :cep, :string

    timestamps()
  end

  def changeset(user \\ %__MODULE__{}, params) do # %__MODULE__ is the same module BananaBank.Users.User
    user
    |> cast(params, @require_params)
    |> validate_required(@require_params)
    |> validate_length(:name, min: 5)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:cep, min: 8)
    |> add_password_hash()
  end

  defp add_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
       changeset(changeset, Argon2.add_hash(password))
  end

  defp add_password_hash(changeset), do: changeset

end
