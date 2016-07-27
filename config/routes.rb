Rails.application.routes.draw do
  get 'new_action', to: 'foreman_datacenter/hosts#new_action'
end
