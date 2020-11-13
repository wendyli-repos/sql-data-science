Error Codes Solutions:
E1:
-- Goal: pull email addresses, but only for non-deleted users.
SELECT 
first_name,
last_name,
email_address,
deleted_at
FROM dsv1069.users
WHERE deleted_at IS NULL;

E2:
-- Goal: count the number of items for sale in each category.
SELECT 
category,
COUNT(*)
FROM dsv1069.items
GROUP BY category

E3:
-- Goal: join the users table with the orders table
SELECT
u.*,
o.*
FROM dsv1069.users u
INNER JOIN dsv1069.orders o ON u.id = o.user_id;

E4:
-- Goal: count the number of viewed_item events
SELECT
COUNT(DISTINCT event_id) AS events 
FROM dsv1069.events
WHERE event_name = 'view_item';

E5:
-- Goal: compute the number of items in the items table which have been ordered
SELECT 
COUNT(DISTINCT o.item_id) AS item_count
FROM dsv1069.orders o
INNER JOIN dsv1069.items i ON o.item_id = i.id
WHERE o.paid_at IS NOT NULL;

E6:
-- Goal: figure out IF a user has ordered something, and when their first purchase was
SELECT 
u.id,
MIN(o.paid_at) AS first_order_time
FROM dsv1069.users u
LEFT JOIN dsv1069.orders o ON u.id = o.user_id
GROUP BY u.id
ORDER BY u.id ASC;

E7:
-- Goal: Figure out what percent of users have ever viewed the user profile page
Logic:
1. Get the earliest event time with event name is view profile
2. Case if the result of Step 1 is true then group and count

My solution: 
SELECT 
1.0 * (SELECT 
COUNT(u.id)
FROM dsv1069.users u
LEFT JOIN dsv1069.events e ON u.id = e.user_id
WHERE e.event_name = 'view_user_profile') /
(
SELECT 
COUNT(*)
FROM dsv1069.users
)
AS percent_of_users_viewed_profile

Recommended solution:
SELECT
  (CASE WHEN first_view IS NULL THEN false
        ELSE true
        END) AS has_viewed_profile_page,
  COUNT(user_id) AS users
FROM 
  (SELECT
    u.id AS user_id,
    MIN(e.event_time) AS first_view
  FROM dsv1069.users u
  LEFT JOIN dsv1069.events e ON u.id = e.user_id
  AND event_name = 'view_user_profile'
  GROUP BY u.id) first_profile_views
GROUP BY 
    (CASE WHEN first_view IS NULL THEN false
          ELSE true
          END) 