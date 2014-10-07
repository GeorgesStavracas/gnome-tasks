CREATE TABLE 'List'
(
  id          INTEGER PRIMARY KEY ASC,
  name        TEXT NOT NULL
);

CREATE TABLE 'Tag'
(
  id          INTEGER PRIMARY KEY ASC,
  name        TEXT NOT NULL,
  color       INTEGER NOT NULL
);

CREATE TABLE 'Task'
(
  id          INTEGER PRIMARY KEY ASC,
  parent      INTEGER,
  list        INTEGER,
  descripion  TEXT NOT NULL,
  completed   INTEGER NOT NULL,
  due_date    DATETIME NOT NULL,
  FOREIGN KEY (parent) REFERENCES Task(id),
  FOREIGN KEY (list) REFERENCES List(id)
);
