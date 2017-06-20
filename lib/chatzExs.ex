defmodule ChatzExs do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      #supervisor(ChatzExs.Repo, []),
      # Start the endpoint when the application starts
      #supervisor(ChatzExs.Endpoint, []),
      # Start your own worker by calling: ChatzExs.Worker.start_link(arg1, arg2, arg3)
      # worker(ChatzExs.Worker, [arg1, arg2, arg3]),
			
			# 1. Start mongo
			worker(Mongo, [[database:
				Application.get_env(:ChatzExs, :db)[:name], name: :mongo]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChatzExs.Supervisor]
    result = Supervisor.start_link(children, opts)

		ChatzExs.StartUp.ensure_indexes
		result
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ChatzExs.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule ChatzExs.Startup do
	def ensure_indexesi do
		IO.puts "Using database #{Application.get_env(:my_app, :db)[:name]}"
    Mongo.command(:mongo, %{createIndexes: "users",
      indexes: [ %{ key: %{ "email": 1 },
                    name: "email_idx",
                    unique: true} ] })
  end
end
