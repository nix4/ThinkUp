-- Due to a Twitter crawler bug, there are cases where a private users's posts were not marked as such.
-- This SQL back-protects posts by protected users.

UPDATE tu_posts, tu_users SET tu_posts.is_protected=1 WHERE tu_posts.author_user_id = tu_users.user_id AND tu_posts.network=tu_users.network AND tu_users.is_protected=1;

-- To check how many posts in your TU database had mismatched privacy setting where the user is protected but post was public, uncomment out and run this SQL:
-- SELECT a.user_name, p.post_id, p.post_text, p.is_protected, a.is_protected FROM tu_posts p INNER JOIN tu_users a ON p.author_user_id=a.user_id AND p.network=a.network WHERE a.is_protected=1 AND p.is_protected=0;
