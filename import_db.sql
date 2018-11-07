PRAGMA foreign_keys = ON;

DROP TABLE question_follows;
DROP TABLE question_likes;
DROP TABLE replies;
DROP TABLE questions;
DROP TABLE users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  parent_id INTEGER,
  body TEXT NOT NULL,
  
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

  INSERT INTO
    users (fname, lname)
  VALUES
    ('Zach', 'Cush'),
    ('Skylar', 'Prill'),
    ('John', 'Smith'),
    ('Debbie', 'Mcaddams');
    
  INSERT INTO
    questions (title, body, author_id)
  VALUES
    ('Time commitment?', 'How many hours per week can I expect to spend on App Academy homework?', 
    (SELECT id FROM users WHERE fname = 'Skylar')),
    ('Building Hours?', 'When do the front doors to App Academy open on saturday morning?', 
    (SELECT id FROM users WHERE fname = 'Zach'));
    
  INSERT INTO
    question_follows (user_id, question_id)
  VALUES
    ((SELECT id FROM users WHERE fname = 'Debbie'), (SELECT id FROM questions WHERE title = 'Time commitment?')),
    (1, 1),
    (1, 2),
    (2, 1),
    (3, 2);
    
  INSERT INTO 
    replies (question_id, user_id, parent_id, body)
  VALUES
    ((SELECT id FROM questions WHERE title = 'Building Hours?'), 
    (SELECT id FROM users WHERE fname = 'Skylar'),
    NULL,
    'I believe the buildings opens at 11am, but don''t quote me on that!'),
    
    
    ((SELECT id FROM questions WHERE title = 'Time commitment?'),
      (SELECT id FROM users WHERE fname = 'John'),
      NULL,
      'You can expect to spend 40 hours per week on homework! Crazy, right?'),
      
    ((SELECT id FROM questions WHERE title = 'Time commitment?'),
      (SELECT id FROM users WHERE fname = 'Debbie'),
      2,
      'Nah man, it''s way closer to 100 hours!'),
      
      (1, 1, 3, 'Golly heck, that''s a lot!'),
      (1, 3, 3, 'Nice! I love work!');

  INSERT INTO
    question_likes (user_id, question_id)
  VALUES
    ((SELECT id FROM users WHERE fname = 'Skylar'), (SELECT id FROM questions WHERE title = 'Time commitment?'));
    
  
  
  
      
    



