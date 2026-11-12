USE amazon_beauty;

-- 1. 제목 또는 본문이 비어 있는 리뷰 개수
SELECT
    SUM(TRIM(title) = '') AS empty_title,
    SUM(TRIM(text) = '')  AS empty_text
FROM reviews_raw;

-- 2. 별점이 1~5 범위를 벗어난 리뷰 개수
SELECT COUNT(*)
FROM reviews_raw
WHERE rating < 1 OR rating > 5;

-- 3. 도움돼요 수가 음수인 리뷰 개수
SELECT COUNT(*)
FROM reviews_raw
WHERE helpful_vote < 0;

-- 4. 중복 리뷰 묶음 개수
SELECT COUNT(*) AS dup_groups
FROM (
    SELECT user_id, asin, timestamp, COUNT(*) AS cnt
    FROM reviews_raw
    GROUP BY user_id, asin, timestamp
    HAVING COUNT(*) > 1
) AS d;

-- 5. 중복으로 제거할 리뷰 수 (묶음마다 1개만 남긴다고 할 때)
SELECT SUM(cnt - 1) AS rows_to_remove
FROM (
    SELECT COUNT(*) AS cnt
    FROM reviews_raw
    GROUP BY user_id, asin, timestamp
    HAVING COUNT(*) > 1
) AS d;

