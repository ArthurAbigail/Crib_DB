This script builds a full relational schema for our crib platform: 
users and auth, separate profiles, media storage, follows, posts (with likes/comments/media), 
events and ticketing with payments, messaging, moderation, and lightweight analytics (counters).
It uses SERIAL auto-increment IDs, FOREIGN KEY constraints to enforce relationships, JSONB where flexible data is needed, 
indexes for performance, and a trigger to keep updated_at timestamps current. 
