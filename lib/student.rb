class Student

attr_accessor :name, :grade
attr_reader :id #we will not be changing the id...needs to be unique

  def initialize(name, grade, id=nil)
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  @id, @name, @grade = id, name, grade
end # NOT SAVED INTO DATABASE UNTIL 'save method!!!'

  def self.create_table
    sql = <<-SQL
  CREATE TABLE IF NOT EXISTS students(
  id INTEGER PRIMARY KEY,
  name TEXT,
  grade TEXT
  )
  SQL
  DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save  ## here we add the values into the database 
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?,?)
    --use bound parameters to avoid issues
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

end
