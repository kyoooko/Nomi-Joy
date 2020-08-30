require 'rails_helper'

RSpec.describe "Admin::Todos", type: :request do
  # ユーザー１はログインユーザー。
  let!(:user_1) { create(:user) }
  let (:req_params) { { todo: { task: "お店に連絡する" } } }
  let!(:todo_1) { Todo.create(user_id: user_1.id, task: "ユーザー１のタスク") }

  describe "ToDoリスト" do
    context "ログインしている場合" do
      before do
        sign_in user_1
      end

      it "タスクの投稿ができること" do
        get admin_events_path
        post admin_user_todos_path(user_1.id), params: req_params, xhr: true
        expect(Todo.find_by(user_id: user_1.id, task: "お店に連絡する")).to be_truthy
      end

      it "タスクの削除ができること" do
        # 引数２つ
        get admin_events_path
        delete admin_user_todo_path(user_1.id, todo_1.id), xhr: true
        expect(Todo.find_by(user_id: user_1.id, task: "ユーザー１のタスク")).to be_falsey
      end
    end
  end
end
