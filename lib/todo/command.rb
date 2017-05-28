# config: utf-8

module Todo # namespace Todoを提供

  class Command

    def execute
      Db.prepare
    end

    def create_task(name, content)
      Task.create!(name: name, content: content).reload
    end

    def destroy_task(id)
      task = Task.find(id)
      task.destroy
    end

    def update_task(id, attributes)
      if state_name = attributes[:state]
        attributes[:state] = Task::STATUS.fetch(state_name.upcase)
      end
      task = Task.find(id)
      task.update_attributes!(attributes)
      task.reload
    end

    def find_tasks(state_name = nil)
      if state_name
        Task.where(state: Task::STATUS.fetch(state_name.upcase)).order('created_at DESC')
      else
        Task.order('created_at DESC')
      end
    end
  end
end
