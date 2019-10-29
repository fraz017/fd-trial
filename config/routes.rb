Rails.application.routes.draw do
  post 'upwork/suspend'
  post 'upwork/restart'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "/recieve-fd" => 'fd#recieve'
end
