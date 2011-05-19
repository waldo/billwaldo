Billwaldo::Application.routes.draw do
  resource :bills, :only => [:new, :create]
  match "bills/:uuid", :as => "bills_view", :to => "bills#show"

  root :to => "bills#new"
end
