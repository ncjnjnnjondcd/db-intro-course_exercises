-- Завдання:
--      Для кожного студента знайти його середній бал у порівнянні з середнім балом по групі
--      Очікувані колонки результату:
--          - ідентифікатор студента (student_id)
--          - повне ім'я студента (full_name)
--          - середній бал студента (avg_student_grade) - округлити результат до 2 знаків після коми
--          - назва групи (group_name)
--          - середній бал по групі (avg_group_grade) - округлити результат до 2 знаків після коми
--      Результат відсортувати за:
--          - за назвою групи, потім за іменем студента

-- Рішення:
WITH StudentAvg AS (
    -- Використовуємо LEFT JOIN, щоб не загубити студентів без оцінок
    SELECT 
        s.student_id,
        p.first_name || ' ' || p.last_name AS full_name,
        s.group_id,
        AVG(e.grade) AS student_raw_avg
    FROM 
        student s
    JOIN 
        person p ON s.person_id = p.person_id
    LEFT JOIN 
        enrolment e ON s.student_id = e.student_id
    GROUP BY 
        s.student_id, p.first_name, p.last_name, s.group_id
)
SELECT 
    sa.student_id,
    sa.full_name,
    ROUND(sa.student_raw_avg, 2)::FLOAT AS avg_student_grade,
    sg.name AS group_name,
    ROUND(AVG(sa.student_raw_avg) OVER (PARTITION BY sg.group_id), 2)::FLOAT AS avg_group_grade
FROM 
    StudentAvg sa
JOIN 
    student_group sg ON sa.group_id = sg.group_id
ORDER BY 
    group_name ASC, 
    full_name ASC;