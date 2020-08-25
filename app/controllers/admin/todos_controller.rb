class Admin::TodosController < ApplicationController
  def create
    @todo = Todo.new(todo_params)
    @todo.user = current_user
    @todo.save if @todo.valid?
    # 非同期実装のため下記削除
    # redirect_back(fallback_location: root_path)
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy if @todo.valid?
    # 非同期実装のため下記削除
    # redirect_back(fallback_location: root_path)
  end

  private

  def todo_params
    params.require(:todo).permit(:task)
  end
end
