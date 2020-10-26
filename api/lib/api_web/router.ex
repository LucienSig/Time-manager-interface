defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug CORSPlug, origin: ["*"]
    plug :accepts, ["json"]
  end

  scope "/api", ApiWeb do
    pipe_through :api

    # Users
    get "/users", UserController, :index
    post "/users", UserController, :create
    get "/users/:userID", UserController, :show
    put "/users/:userID", UserController, :update
    delete "/users/:userID", UserController, :delete

    # Worktimes
    get "/workingtimes/:userID", WorkingTimeController, :index
    get "/workingtimes/:userID/:workingtimeID", WorkingTimeController, :show
    post "/workingtimes/:userID", WorkingTimeController, :create
    put "/workingtimes/:id", WorkingTimeController, :change
    delete "/workingtimes/:id", WorkingTimeController, :delete

    # Clocking
    get "/clocks/:userID", ClockController, :read
    post "/clocks/:userID", ClockController, :create

    # Charts
    get "/charts/:userID", ChartController, :index
    get "/charts/:userID/:chartID", ChartController, :show
    post "/charts", ChartController, :create
    put "/charts/:chartID", ChartController, :change
  end

  # Other scopes may use custom stacks.
  # scope "/api", ApiWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
end
