Billwaldo::Application.routes.draw do
  resource :bills, :only => [:new, :create]

  match "bills/:uuid", :as => "bills_view", :to => "bills#show"
  match "bills/:uuid/expenses/create", :as => "expenses_create", :to => "expenses#create"
  match "bills/:uuid/people/create", :as => "people_create", :to => "bills#add_person"

  root :to => "bills#new"
end
