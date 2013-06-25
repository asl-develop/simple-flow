SimpleFlow::Application.routes.draw do

  root :to => 'tasks#index'

  resources :users do
  end

  resources :tasks do
    member {put "save", "apply", "cancel", "delete", "approve", "finish", "revoke"} # 保存、申請、キャンセル、削除、承認、完了、取り消し
  end

  resources :sessions, only: [:new]do
  end
  resource :session, only: [:create, :destroy] do
  end


end
