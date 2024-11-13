from collections import List
from python import Python as py
from time import time

# Person構造体を定義
struct Person:
    var name: String
    var age: Int
    
    fn __init__(inout self, name: String, age: Int):
        self.name = name
        self.age = age

# Table構造体
struct Table:
    var table_name: String
    var names: List[String]
    var ages: List[Int]
    
    fn __init__(inout self, table_name: String):
        self.table_name = table_name
        self.names = List[String]()
        self.ages = List[Int]()

    fn insert(inout self, person: Person):
        self.names.append(person.name)
        self.ages.append(person.age)

    fn select_by_name(self, search_name: String):
        var found = False
        for i in range(len(self.names)):
            if self.names[i] == search_name:
                print("Name:", self.names[i], "Age:", self.ages[i])
                found = True
        if not found:
            print("No records found with the name", search_name)

# Database構造体
struct Database:
    var table_names: List[String]
    var tables_names: List[List[String]]
    var tables_ages: List[List[Int]]
    
    fn __init__(inout self):
        self.table_names = List[String]()
        self.tables_names = List[List[String]]()
        self.tables_ages = List[List[Int]]()

    fn add_table(inout self, table: Table):
        # テーブル名を追加し、新しいテーブル用のリストを初期化
        self.table_names.append(table.table_name)
        self.tables_names.append(table.names)
        self.tables_ages.append(table.ages)

    fn show_table(self, table_name: String):
        # 指定されたテーブル名が存在するか確認し、内容を表示
        for i in range(len(self.table_names)):
            if self.table_names[i] == table_name:
                print("Table:", self.table_names[i])
                for j in range(len(self.tables_names[i])):
                    print("Name:", self.tables_names[i][j], ", Age:", self.tables_ages[i][j])
                return
        print("Table not found.")

# CLIでユーザー操作を入力
fn main() -> None:
    try:
        var input = py.import_module("builtins").input
        var db = Database()
        db.__init__()

        while True:
            print("\nChoose an operation:")
            print("1: Create Table")
            print("2: Add Person to Table")
            print("3: Search by Name")
            print("4: Show Table")
            print("5: Exit")
            var choice = str(input("Enter choice (1-5): "))

            if choice == "1":
                var table_name = str(input("Enter table name: "))
                var table = Table(table_name)
                db.add_table(table)
                print("Table", table_name, "created.")
                var file_path = "src/table.csv"
                var text : String
                with open(file_path, "r") as f:
                    text = f.read()
                with open(file_path, "w") as f:
                    var new_line = table_name + "," + str(time.now())
                    var new_text = text + "\n" + new_line
                    f.write(str(new_text))

            elif choice == "2":
                var table_name = str(input("Enter table name to add person: "))
                var name = str(input("Enter person's name: "))
                var age = 0
                try:
                    age = int(str(input("Enter person's age: ")))
                except:
                    print("Invalid age, please enter a number.")
                    continue
                for i in range(len(db.table_names)):
                    if db.table_names[i] == table_name:
                        db.tables_names[i].append(name)
                        db.tables_ages[i].append(age)
                        print("Person added to", table_name)
                        break
                else:
                    print("Table", table_name, "not found.")

            elif choice == "3":
                var table_name = str(input("Enter table name to search: "))
                var search_name = str(input("Enter name to search: "))
                var found = False
                for i in range(len(db.table_names)):
                    if db.table_names[i] == table_name:
                        for j in range(len(db.tables_names[i])):
                            if db.tables_names[i][j] == search_name:
                                print("Name:", db.tables_names[i][j], ", Age:", db.tables_ages[i][j])
                                found = True
                        if not found:
                            print("No records found with the name", search_name)
                        break
                else:
                    print("Table", table_name, "not found.")

            elif choice == "4":
                var table_name = str(input("Enter table name to show: "))
                db.show_table(table_name)

            elif choice == "5":
                print("Exiting...")
                break

            else:
                print("Invalid choice, please select 1-5.")
    except:
        print("An error occurred.")
