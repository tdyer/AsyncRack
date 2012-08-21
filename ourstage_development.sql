--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

--
-- Name: dblink_pkey_results; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE dblink_pkey_results AS (
	"position" integer,
	colname text
);


--
-- Name: media_item_results_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE media_item_results_type AS (
	media_item_id integer,
	genre character varying(256),
	contest_id integer,
	start_time timestamp without time zone,
	rank integer,
	judgers integer,
	avg_battle_power real,
	contest_health real
);


--
-- Name: media_item_results_type_2; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE media_item_results_type_2 AS (
	media_item_id integer,
	genre character varying(255),
	contest_id integer,
	start_time timestamp without time zone,
	rank integer,
	judgers integer,
	avg_battle_power real,
	contest_health real
);


--
-- Name: mojo_thumb_rating_results_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE mojo_thumb_rating_results_type AS (
	media_item_id integer,
	score real,
	rating_count integer,
	rating_avg real,
	rec_count integer,
	rec_avg real
);


--
-- Name: mojo_track_features_results_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE mojo_track_features_results_type AS (
	media_item_id integer,
	created_at timestamp without time zone
);


--
-- Name: crc32(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION crc32(word text) RETURNS bigint
    AS $$
          DECLARE tmp bigint;
          DECLARE i int;
          DECLARE j int;
          DECLARE byte_length int;
          DECLARE word_array bytea;
          BEGIN
            IF COALESCE(word, '') = '' THEN
              return 0;
            END IF;

            i = 0;
            tmp = 4294967295;
            byte_length = bit_length(word) / 8;
            word_array = decode(replace(word, E'\\', E'\\\\'), 'escape');
            LOOP
              tmp = (tmp # get_byte(word_array, i))::bigint;
              i = i + 1;
              j = 0;
              LOOP
                tmp = ((tmp >> 1) # (3988292384 * (tmp & 1)))::bigint;
                j = j + 1;
                IF j >= 8 THEN
                  EXIT;
                END IF;
              END LOOP;
              IF i >= byte_length THEN
                EXIT;
              END IF;
            END LOOP;
            return (tmp # 4294967295);
          END
        $$
    LANGUAGE plpgsql IMMUTABLE;


--
-- Name: dblink(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink(text, text) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_record'
    LANGUAGE c STRICT;


--
-- Name: dblink(text, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink(text, text, boolean) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_record'
    LANGUAGE c STRICT;


--
-- Name: dblink(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink(text) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_record'
    LANGUAGE c STRICT;


--
-- Name: dblink(text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink(text, boolean) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_record'
    LANGUAGE c STRICT;


--
-- Name: dblink_build_sql_delete(text, int2vector, integer, text[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_build_sql_delete(text, int2vector, integer, text[]) RETURNS text
    AS '$libdir/dblink', 'dblink_build_sql_delete'
    LANGUAGE c STRICT;


--
-- Name: dblink_build_sql_insert(text, int2vector, integer, text[], text[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_build_sql_insert(text, int2vector, integer, text[], text[]) RETURNS text
    AS '$libdir/dblink', 'dblink_build_sql_insert'
    LANGUAGE c STRICT;


--
-- Name: dblink_build_sql_update(text, int2vector, integer, text[], text[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_build_sql_update(text, int2vector, integer, text[], text[]) RETURNS text
    AS '$libdir/dblink', 'dblink_build_sql_update'
    LANGUAGE c STRICT;


--
-- Name: dblink_cancel_query(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_cancel_query(text) RETURNS text
    AS '$libdir/dblink', 'dblink_cancel_query'
    LANGUAGE c STRICT;


--
-- Name: dblink_close(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_close(text) RETURNS text
    AS '$libdir/dblink', 'dblink_close'
    LANGUAGE c STRICT;


--
-- Name: dblink_close(text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_close(text, boolean) RETURNS text
    AS '$libdir/dblink', 'dblink_close'
    LANGUAGE c STRICT;


--
-- Name: dblink_close(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_close(text, text) RETURNS text
    AS '$libdir/dblink', 'dblink_close'
    LANGUAGE c STRICT;


--
-- Name: dblink_close(text, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_close(text, text, boolean) RETURNS text
    AS '$libdir/dblink', 'dblink_close'
    LANGUAGE c STRICT;


--
-- Name: dblink_connect(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_connect(text) RETURNS text
    AS '$libdir/dblink', 'dblink_connect'
    LANGUAGE c STRICT;


--
-- Name: dblink_connect(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_connect(text, text) RETURNS text
    AS '$libdir/dblink', 'dblink_connect'
    LANGUAGE c STRICT;


--
-- Name: dblink_connect_u(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_connect_u(text) RETURNS text
    AS '$libdir/dblink', 'dblink_connect'
    LANGUAGE c STRICT SECURITY DEFINER;


--
-- Name: dblink_connect_u(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_connect_u(text, text) RETURNS text
    AS '$libdir/dblink', 'dblink_connect'
    LANGUAGE c STRICT SECURITY DEFINER;


--
-- Name: dblink_current_query(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_current_query() RETURNS text
    AS '$libdir/dblink', 'dblink_current_query'
    LANGUAGE c;


--
-- Name: dblink_disconnect(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_disconnect() RETURNS text
    AS '$libdir/dblink', 'dblink_disconnect'
    LANGUAGE c STRICT;


--
-- Name: dblink_disconnect(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_disconnect(text) RETURNS text
    AS '$libdir/dblink', 'dblink_disconnect'
    LANGUAGE c STRICT;


--
-- Name: dblink_error_message(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_error_message(text) RETURNS text
    AS '$libdir/dblink', 'dblink_error_message'
    LANGUAGE c STRICT;


--
-- Name: dblink_exec(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_exec(text, text) RETURNS text
    AS '$libdir/dblink', 'dblink_exec'
    LANGUAGE c STRICT;


--
-- Name: dblink_exec(text, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_exec(text, text, boolean) RETURNS text
    AS '$libdir/dblink', 'dblink_exec'
    LANGUAGE c STRICT;


--
-- Name: dblink_exec(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_exec(text) RETURNS text
    AS '$libdir/dblink', 'dblink_exec'
    LANGUAGE c STRICT;


--
-- Name: dblink_exec(text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_exec(text, boolean) RETURNS text
    AS '$libdir/dblink', 'dblink_exec'
    LANGUAGE c STRICT;


--
-- Name: dblink_fetch(text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_fetch(text, integer) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_fetch'
    LANGUAGE c STRICT;


--
-- Name: dblink_fetch(text, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_fetch(text, integer, boolean) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_fetch'
    LANGUAGE c STRICT;


--
-- Name: dblink_fetch(text, text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_fetch(text, text, integer) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_fetch'
    LANGUAGE c STRICT;


--
-- Name: dblink_fetch(text, text, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_fetch(text, text, integer, boolean) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_fetch'
    LANGUAGE c STRICT;


--
-- Name: dblink_get_connections(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_get_connections() RETURNS text[]
    AS '$libdir/dblink', 'dblink_get_connections'
    LANGUAGE c;


--
-- Name: dblink_get_pkey(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_get_pkey(text) RETURNS SETOF dblink_pkey_results
    AS '$libdir/dblink', 'dblink_get_pkey'
    LANGUAGE c STRICT;


--
-- Name: dblink_get_result(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_get_result(text) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_get_result'
    LANGUAGE c STRICT;


--
-- Name: dblink_get_result(text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_get_result(text, boolean) RETURNS SETOF record
    AS '$libdir/dblink', 'dblink_get_result'
    LANGUAGE c STRICT;


--
-- Name: dblink_is_busy(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_is_busy(text) RETURNS integer
    AS '$libdir/dblink', 'dblink_is_busy'
    LANGUAGE c STRICT;


--
-- Name: dblink_open(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_open(text, text) RETURNS text
    AS '$libdir/dblink', 'dblink_open'
    LANGUAGE c STRICT;


--
-- Name: dblink_open(text, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_open(text, text, boolean) RETURNS text
    AS '$libdir/dblink', 'dblink_open'
    LANGUAGE c STRICT;


--
-- Name: dblink_open(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_open(text, text, text) RETURNS text
    AS '$libdir/dblink', 'dblink_open'
    LANGUAGE c STRICT;


--
-- Name: dblink_open(text, text, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_open(text, text, text, boolean) RETURNS text
    AS '$libdir/dblink', 'dblink_open'
    LANGUAGE c STRICT;


--
-- Name: dblink_send_query(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION dblink_send_query(text, text) RETURNS integer
    AS '$libdir/dblink', 'dblink_send_query'
    LANGUAGE c STRICT;


--
-- Name: demographic_age_group(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION demographic_age_group(years_old integer) RETURNS integer
    AS $$
BEGIN
   RETURN CASE 
    WHEN years_old >= 55 THEN 55
    WHEN years_old >= 45 THEN 45
    WHEN years_old >= 35 THEN 35
    WHEN years_old >= 25 THEN 25
    WHEN years_old >= 18 THEN 18
    WHEN years_old >= 13 THEN 13
    ELSE 0 
    END;
END;
$$
    LANGUAGE plpgsql;


--
-- Name: flat_battle_contest(integer, integer, integer, boolean, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION flat_battle_contest(contest_id integer, def_score integer, run_limit integer, run_commit boolean, use_latest_battle_power boolean) RETURNS integer
    AS $$
DECLARE
  r_battle RECORD;   -- record read when looping through battle table
  r_entry RECORD;    -- record read when looping through entry table
  f_num_battles int; -- number of countable battles an entry has had
  score_1 int;       -- current entry 1 score at time of battle
  score_2 int;       -- current entry 2 score at time of battle
  increment_1 double precision;      -- ELO score increment for entry 1
  increment_2 double precision;      -- ELO score increment for entry 2
  f_new_entry_1_score integer;       -- ELO new score for entry 1
  f_new_entry_2_score integer;       -- ELO new score for entry 2
  f_k_val double precision;          -- ELO k value to be used for given battle
  f_potency double precision;        -- battle power for user doing a battle
BEGIN
  -- temp table for remembering current entry scores
  DROP TABLE IF EXISTS t_flat_entry_scores;
  CREATE TEMP TABLE t_flat_entry_scores(eid integer, score integer, num_battles integer);
  CREATE INDEX t_flat_entry_scores_pkey ON t_flat_entry_scores(eid);
  
  -- IF run_commit THEN
  --  RAISE NOTICE 'Run and COMMIT changes';
  -- ELSE
  --  RAISE NOTICE 'Run and DO NOT COMMIT changes';
  -- END IF;
  
  -- #########################################################################
  -- Loop through all valid battles
  FOR r_battle IN SELECT * FROM battles 
                   WHERE battles.contest_id = contest_id
                     AND battles.battle_type = 0
                     AND (battles.disqualified = 0 OR battles.disqualified IS NULL)
                   ORDER BY battles.scored_at, battles.id LIMIT run_limit LOOP

    -- look up latest entry 1 score from the temp table
    SELECT score INTO score_1 FROM t_flat_entry_scores WHERE t_flat_entry_scores.eid = r_battle.entry_1_id LIMIT 1;
    IF score_1 IS NULL THEN
      score_1 := def_score;
    END IF;
    -- look up latest entry 2 score from the temp table
    SELECT score INTO score_2 FROM t_flat_entry_scores WHERE t_flat_entry_scores.eid = r_battle.entry_2_id LIMIT 1;
    IF score_2 IS NULL THEN
      score_2 := def_score;
    END IF;
    -- Set scores to current value for no-pref or no battle power, and NULL for disqualified battles
    IF r_battle.score = 0 OR r_battle.battle_power = 0 OR r_battle.disqualified != 0 THEN
      IF r_battle.disqualified != 0 THEN
        f_new_entry_1_score := NULL;
        f_new_entry_2_score := NULL;
      ELSE
        f_new_entry_1_score := score_1;
        f_new_entry_2_score := score_2;
      END IF;
    ELSE
      -- This is where the battle counted
      -- Note: this assumes contests start and stop on month boundaries
      f_k_val          := (32.0 - ((date_part('day',r_battle.scored_at) - 1.0) * 0.7619)) * 1000; 

      IF use_latest_battle_power THEN
        SELECT rating INTO f_potency
          FROM battle_behavior_ratings
         WHERE battle_type IS NULL 
           AND behavior_class_name = 'BattlePower'
           AND user_id    = r_battle.user_id
           AND contest_id = r_battle.contest_id
          ORDER BY id
         LIMIT 1;
      ELSE      -- get potency from battle
        f_potency := r_battle.battle_power;
      END IF;
      
      IF f_potency IS NULL THEN
        f_potency := 1.0;
      END IF;

      IF r_battle.score < 0 THEN
        increment_1 := 100 * f_potency * f_k_val;
        increment_2 := -100 * f_potency * f_k_val;
      ELSE
        increment_1 := -100 * f_potency * f_k_val;
        increment_2 := 100 * f_potency * f_k_val;
      END IF;

      f_new_entry_1_score := score_1 + CAST(increment_1 AS int);
      f_new_entry_2_score := score_2 + CAST(increment_2 AS int);
    END IF;

    UPDATE t_flat_entry_scores
      SET score = f_new_entry_1_score, num_battles = num_battles + 1
      WHERE eid = r_battle.entry_1_id;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
      INSERT INTO t_flat_entry_scores VALUES (r_battle.entry_1_id, f_new_entry_1_score, 1);
    END IF;
    -- entry2
    UPDATE t_flat_entry_scores
      SET score = f_new_entry_2_score, num_battles = num_battles + 1
      WHERE eid = r_battle.entry_2_id;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
      INSERT INTO t_flat_entry_scores VALUES (r_battle.entry_2_id, f_new_entry_2_score, 1);
    END IF;

  END LOOP;

  RETURN 0;
END;
$$
    LANGUAGE plpgsql;


--
-- Name: mojo_all_competition_rank_info(timestamp without time zone, timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mojo_all_competition_rank_info(start_time timestamp without time zone, end_time timestamp without time zone, num_items integer) RETURNS SETOF media_item_results_type_2
    AS $$
DECLARE

rank record;

BEGIN

  DROP TABLE IF EXISTS t_contest_stats;
  CREATE TEMP TABLE t_contest_stats(contest_id integer, genre_name varchar(255), start_date timestamp, judgers integer, avg_battle_power REAL, contest_health REAL);

  -- Get the list of channels that matter
  DROP TABLE IF EXISTS t_contests2consider;
  CREATE TEMP TABLE t_contests2consider(contest_id INTEGER);
  INSERT INTO t_contests2consider (SELECT contests.id FROM contests
  WHERE 
     DATE_TRUNC('month', contests.start_date) >= DATE_TRUNC('month', start_time)
     AND DATE_TRUNC('month', contests.start_date) < end_time
     AND (contests.flags & (1 << 3)) = 0     -- not cancelled
     -- breaks the intermediate results
     --AND contests.first_place_entry_id IS NOT NULL
     );

  -- Gather usage stats for the contest, only include completed contests flag 4 during the date range
  INSERT INTO t_contest_stats(contest_id, genre_name, start_date, judgers, avg_battle_power, contest_health) 
   (SELECT augmented_battles.contest_id, augmented_contests.genre_name, augmented_contests.start_date, augmented_battles.judgers, augmented_battles.avg_battle_power, (CASE augmented_contests.qe WHEN 0 THEN 0 ELSE CAST(augmented_contests.pb AS FLOAT) / CAST(augmented_contests.qe AS FLOAT) END) AS contest_health
   FROM 
     (select battle_behavior_ratings.contest_id, COUNT(battle_behavior_ratings.user_id) AS judgers, AVG(battle_behavior_ratings.rating) as avg_battle_power 
     FROM battle_behavior_ratings 
     JOIN users ON users.id = battle_behavior_ratings.user_id
     WHERE behavior_class_name = 'BattlePower' 
     AND (users.flags & 1) = 0
     AND contest_id IN (SELECT DISTINCT contest_id FROM t_contests2consider)
     GROUP BY contest_id)
     AS augmented_battles
   JOIN
     (SELECT contests.*, 
      (SELECT COUNT(*) FROM battles WHERE battles.contest_id = contests.id AND battles.disqualified=0) AS pb, 
      (SELECT COUNT(*) FROM entries WHERE entries.contest_id = contests.id AND entries.disqualified=0 AND entries.withdrawn=0) AS qe,
      (SELECT key FROM classify_genres WHERE id IN (SELECT genre_id from channel_genres where channel_id = contests.channel_id) ORDER BY (rgt-lft) LIMIT 1) AS genre_name 
      FROM contests 
      WHERE id in (SELECT DISTINCT contest_id FROM t_contests2consider))
      AS augmented_contests 
     ON augmented_contests.id=augmented_battles.contest_id);

   IF (DATE_TRUNC('month', end_time) = DATE_TRUNC('day', end_time)) THEN     -- get final contest results
    
     -- Return the data from the t_contest_stats table
     RETURN QUERY SELECT entries.media_item_id,
                         t_contest_stats.genre_name,
                         t_contest_stats.contest_id,
                         t_contest_stats.start_date,
                         entries.rank AS final_rank,
                         t_contest_stats.judgers,
                         t_contest_stats.avg_battle_power,
                         t_contest_stats.contest_health
       FROM t_contest_stats
       JOIN entries ON entries.contest_id = t_contest_stats.contest_id
       WHERE entries.disqualified=0 AND entries.withdrawn=0 AND entries.rank <= num_items;

  ELSE          -- get intermediate contest results
  
    RETURN QUERY SELECT 
        entries.media_item_id, 
        t_contest_stats.genre_name, 
        t_contest_stats.contest_id,
        t_contest_stats.start_date, 
        entry_rank_trackers.rank AS final_rank, 
        t_contest_stats.judgers,
        t_contest_stats.avg_battle_power,
        t_contest_stats.contest_health
      FROM t_contest_stats
      JOIN entries ON entries.contest_id = t_contest_stats.contest_id
      JOIN (SELECT contest_id, MAX(snapshot_at) as snapshot_at FROM entry_rank_trackers 
        WHERE contest_id in (SELECT DISTINCT contest_id FROM t_contest_stats) 
        AND DATE_TRUNC('day', snapshot_at) < end_time GROUP BY contest_id) 
        AS snapshots ON snapshots.contest_id = t_contest_stats.contest_id
      JOIN entry_rank_trackers ON entry_rank_trackers.contest_id = t_contest_stats.contest_id 
        AND entry_rank_trackers.entry_id = entries.id 
        AND entry_rank_trackers.snapshot_at = snapshots.snapshot_at
      WHERE entries.disqualified=0 AND entries.withdrawn=0 
      AND entry_rank_trackers.rank < num_items;
    
  END IF;
END;

$$
    LANGUAGE plpgsql;


--
-- Name: mojo_competition_rank_info(character varying, timestamp without time zone, timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mojo_competition_rank_info(genre_key character varying, start_time timestamp without time zone, end_time timestamp without time zone, num_items integer) RETURNS SETOF media_item_results_type
    AS $$
DECLARE

rank record;

BEGIN

  DROP TABLE IF EXISTS t_contest_stats;
  CREATE TEMP TABLE t_contest_stats(contest_id integer, start_date timestamp, judgers integer, avg_battle_power REAL, contest_health REAL);

  -- Get the list of channels that matter
  DROP TABLE IF EXISTS t_contests2consider;
  CREATE TEMP TABLE t_contests2consider(contest_id INTEGER);
  INSERT INTO t_contests2consider (SELECT contests.id FROM channel_genres
    JOIN classify_genres ON channel_genres.genre_id=classify_genres.id
    JOIN contests ON channel_genres.channel_id=contests.channel_id
  WHERE classify_genres.lft >= (SELECT lft FROM classify_genres WHERE key = genre_key)
     AND classify_genres.rgt <= (SELECT rgt FROM classify_genres WHERE key = genre_key)
     AND DATE_TRUNC('month', contests.start_date) >= DATE_TRUNC('month', start_time)
     AND DATE_TRUNC('month', contests.start_date) < end_time
     AND (contests.flags & (1 << 3)) = 0     -- not cancelled
     -- breaks the intermediate results
     --AND contests.first_place_entry_id IS NOT NULL
     );

  -- Gather usage stats for the contest, only include completed contests flag 4 during the date range
  INSERT INTO t_contest_stats(contest_id, start_date, judgers, avg_battle_power, contest_health) 
   (SELECT augmented_battles.contest_id, augmented_contests.start_date, augmented_battles.judgers, augmented_battles.avg_battle_power, (CASE augmented_contests.qe WHEN 0 THEN 0 ELSE CAST(augmented_contests.pb AS FLOAT) / CAST(augmented_contests.qe AS FLOAT) END) AS contest_health
   FROM 
     (select battle_behavior_ratings.contest_id, COUNT(battle_behavior_ratings.user_id) AS judgers, AVG(battle_behavior_ratings.rating) as avg_battle_power 
     FROM battle_behavior_ratings 
     JOIN users ON users.id = battle_behavior_ratings.user_id
     WHERE behavior_class_name = 'BattlePower' 
     AND (users.flags & 1) = 0
     AND contest_id IN (SELECT DISTINCT contest_id FROM t_contests2consider)
     GROUP BY contest_id)
     AS augmented_battles
   JOIN
     (SELECT contests.*, 
      (SELECT COUNT(*) FROM battles WHERE battles.contest_id = contests.id AND battles.disqualified=0) AS pb, 
      (SELECT COUNT(*) FROM entries WHERE entries.contest_id = contests.id AND entries.disqualified=0 AND entries.withdrawn=0) AS qe
      FROM contests 
      WHERE id in (SELECT DISTINCT contest_id FROM t_contests2consider))
      AS augmented_contests 
     ON augmented_contests.id=augmented_battles.contest_id);

   IF (DATE_TRUNC('month', end_time) = DATE_TRUNC('day', end_time)) THEN     -- get final contest results
    
     -- Return the data from the t_contest_stats table
     RETURN QUERY SELECT entries.media_item_id,
                         genre_key,
                         t_contest_stats.contest_id,
                         t_contest_stats.start_date,
                         entries.rank AS final_rank,
                         t_contest_stats.judgers,
                         t_contest_stats.avg_battle_power,
                         t_contest_stats.contest_health
       FROM t_contest_stats
       JOIN entries ON entries.contest_id = t_contest_stats.contest_id
       WHERE entries.disqualified=0 AND entries.withdrawn=0 AND entries.rank <= num_items;

  ELSE          -- get intermediate contest results
  
    RETURN QUERY SELECT 
        entries.media_item_id, 
        genre_key, 
        t_contest_stats.contest_id,
        t_contest_stats.start_date, 
        entry_rank_trackers.rank AS final_rank, 
        t_contest_stats.judgers,
        t_contest_stats.avg_battle_power,
        t_contest_stats.contest_health
      FROM t_contest_stats
      JOIN entries ON entries.contest_id = t_contest_stats.contest_id
      JOIN (SELECT contest_id, MAX(snapshot_at) as snapshot_at FROM entry_rank_trackers 
        WHERE contest_id in (SELECT DISTINCT contest_id FROM t_contest_stats) 
        AND DATE_TRUNC('day', snapshot_at) < end_time GROUP BY contest_id) 
        AS snapshots ON snapshots.contest_id = t_contest_stats.contest_id
      JOIN entry_rank_trackers ON entry_rank_trackers.contest_id = t_contest_stats.contest_id 
        AND entry_rank_trackers.entry_id = entries.id 
        AND entry_rank_trackers.snapshot_at = snapshots.snapshot_at
      WHERE entries.disqualified=0 AND entries.withdrawn=0 
      AND entry_rank_trackers.rank < num_items;
    
  END IF;
END;

$$
    LANGUAGE plpgsql;


--
-- Name: mojo_thumb_ratings(character varying, timestamp without time zone, timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mojo_thumb_ratings(genre_key character varying, start_time timestamp without time zone, end_time timestamp without time zone, num_items integer) RETURNS SETOF mojo_thumb_rating_results_type
    AS $$
BEGIN

RETURN QUERY SELECT DISTINCT media_items.id AS media_item_id,
  CAST(0.1*LOG(COUNT(DISTINCT media_item_ratings.id))*AVG(media_item_ratings.rating) + 
  0.2*AVG(CASE WHEN recommendations.id IS NULL THEN 0 ELSE recommendations.rating END)*LOG(COUNT(DISTINCT recommendations.id)) AS REAL) as score,
  CAST(COUNT(DISTINCT media_item_ratings.id) AS INTEGER) as rating_count, 
  CAST (AVG(media_item_ratings.rating) AS REAL) as rating_avg,
  CAST(COUNT(DISTINCT recommendations.id) AS INTEGER) as rec_count, 
  CAST(AVG(CASE WHEN recommendations.id IS NULL THEN 0 ELSE recommendations.rating END) AS REAL) as rec_avg
  FROM media_items 
  JOIN classify_media_item_genres ON classify_media_item_genres.media_item_id = media_items.id
  JOIN media_item_ratings ON media_item_ratings.media_item_id = media_items.id
  LEFT OUTER JOIN recommendations ON recommendations.media_item_id = media_items.id
  WHERE 
  recommendations.rating IS NOT NULL AND
  genre_id IN (
  SELECT id from classify_genres 
  WHERE lft >= (SELECT lft FROM classify_genres WHERE key = genre_key)
  AND rgt <= (SELECT rgt FROM classify_genres WHERE key = genre_key))
  AND media_item_ratings.created_at >= start_time AND media_item_ratings.created_at < end_time
  GROUP BY media_items.id
  HAVING COUNT(DISTINCT media_item_ratings.id) >= 2
  ORDER BY score desc
  LIMIT num_items;

END;

$$
    LANGUAGE plpgsql;


--
-- Name: mojo_track_features(character varying, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION mojo_track_features(genre_key character varying, start_time timestamp without time zone, end_time timestamp without time zone) RETURNS SETOF mojo_track_features_results_type
    AS $$
BEGIN

RETURN QUERY SELECT media_item_id, MAX(playlists_items.created_at)
  FROM playlists_items
  JOIN channels ON channels.editorial_playlist_id = playlists_items.playlist_id
  JOIN channel_genres ON channel_genres.channel_id = channels.id
  JOIN classify_genres ON channel_genres.genre_id=classify_genres.id
  WHERE classify_genres.lft >= (SELECT lft FROM classify_genres WHERE key = genre_key)
     AND classify_genres.rgt <= (SELECT rgt FROM classify_genres WHERE key = genre_key)
     AND playlists_items.created_at < end_time
  GROUP BY media_item_id
  ORDER BY media_item_id;

END;
$$
    LANGUAGE plpgsql;


--
-- Name: pg_buffercache_pages(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pg_buffercache_pages() RETURNS SETOF record
    AS '$libdir/pg_buffercache', 'pg_buffercache_pages'
    LANGUAGE c;


--
-- Name: qaos_process_battles(timestamp without time zone, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION qaos_process_battles(contest_phase_stop_time timestamp without time zone, decline_duration integer, cliff_duration integer, process_limit integer) RETURNS integer
    AS $$
DECLARE
  r_battle RECORD;   -- record read when looping through battle table
  increment_1 integer;      -- QAOS score increment for entry 1
  increment_2 integer;      -- QAOS score increment for entry 2
  f_k_val double precision;          -- k value to be used for given battle
  start_decline timestamp;           -- time that k starts to decline
  start_cliff timestamp;             -- time that k falls off the cliff
  last_battle_time timestamp;
  battle_count integer;
  up1 integer;
  up2 integer;
  down1 integer;
  down2 integer;

BEGIN

  battle_count := 0;
  last_battle_time := (SELECT scored_at from qaos_last_battle_processed);

  start_decline := contest_phase_stop_time - CAST(decline_duration + cliff_duration || ' seconds' AS INTERVAL);
  start_cliff := contest_phase_stop_time - CAST(cliff_duration || ' seconds' AS INTERVAL);

  FOR r_battle IN SELECT battles.id, battles.user_id, battles.contest_id, battles.battle_type, battles.score, battles.entry_1_id, battles.entry_2_id, battles.scored_at
                 FROM battles
                 WHERE battles.scored_at > last_battle_time
                 AND battles.score != 0
                 AND battles.disqualified = 0
                 ORDER BY scored_at limit process_limit LOOP

    -- Calculate K the same as before so we match up with the existing scores we need a 320 multiplier
    IF r_battle.scored_at < start_decline THEN
      f_k_val := 3200;
    ELSE
      IF r_battle.scored_at < start_cliff THEN
        -- calc k as 100% down 50% of 3200 of the decline
        f_k_val := (((EXTRACT(EPOCH FROM (start_cliff - r_battle.scored_at)) / decline_duration) * 50) + 50) * 32;
      ELSE
        -- calc k as 50% down to 0% of 3200
        f_k_val := ((EXTRACT(EPOCH FROM (contest_phase_stop_time - r_battle.scored_at)) / cliff_duration) * 50) * 32;
      END IF;
    END IF;

    up1 := 0;
    up2 := 0;
    down1 := 0;
    down2 := 0;

    IF r_battle.score < 0 THEN
      increment_1 := CAST(f_k_val AS int);
      increment_2 := -1 * increment_1;
      up1 := 1;
      down2 := 1;
    ELSE
      increment_2 := CAST(f_k_val AS int);
      increment_1 := -1 * increment_2;
      up2 := 1;
      down1 := 1;
    END IF;

    -- entry1
    UPDATE qaos_user_entry_scores SET score = score + increment_1, ups = ups + up1, downs = downs + down1
      WHERE qaos_user_entry_scores.user_id = r_battle.user_id AND qaos_user_entry_scores.entry_id=r_battle.entry_1_id AND qaos_user_entry_scores.contest_id=r_battle.contest_id AND qaos_user_entry_scores.phase=r_battle.battle_type;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
      INSERT INTO qaos_user_entry_scores(user_id, contest_id, entry_id, phase, score, ups, downs) VALUES (r_battle.user_id, r_battle.contest_id, r_battle.entry_1_id, r_battle.battle_type, increment_1, up1, down1);
    END IF;
    -- entry2
    UPDATE qaos_user_entry_scores SET score = score + increment_2, ups = ups + up2, downs = downs + down2
      WHERE qaos_user_entry_scores.user_id = r_battle.user_id AND qaos_user_entry_scores.entry_id=r_battle.entry_2_id AND qaos_user_entry_scores.contest_id=r_battle.contest_id AND qaos_user_entry_scores.phase=r_battle.battle_type;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
      INSERT INTO qaos_user_entry_scores(user_id, contest_id, entry_id, phase, score, ups, downs) VALUES (r_battle.user_id, r_battle.contest_id, r_battle.entry_2_id, r_battle.battle_type, increment_2, up2, down2);
    END IF;
    
    battle_count := battle_count + 1;
    last_battle_time := r_battle.scored_at;
  END LOOP;

  UPDATE qaos_last_battle_processed SET scored_at = last_battle_time;

  RETURN battle_count;

END;
$$
    LANGUAGE plpgsql;


--
-- Name: qaos_process_battles(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION qaos_process_battles(process_limit integer) RETURNS integer
    AS $$
DECLARE
  r_battle RECORD;   -- record read when looping through battle table
  current_phase RECORD;     -- Get the stats for the current contests current phase
  increment_1 integer;      -- QAOS score increment for entry 1
  increment_2 integer;      -- QAOS score increment for entry 2
  f_k_val double precision;          -- k value to be used for given battle
  start_decline timestamp;           -- time that k starts to decline
  start_cliff timestamp;             -- time that k falls off the cliff
  last_battle_time timestamp;
  battle_count integer;
  up1 integer;
  up2 integer;
  down1 integer;
  down2 integer;
  cliff_duration integer;
  decline_duration integer;
  
BEGIN

  battle_count := 0;
  last_battle_time := (SELECT scored_at from qaos_last_battle_processed);

  FOR r_battle IN SELECT battles.id, battles.user_id, battles.contest_id, battles.battle_type, battles.score, battles.entry_1_id, battles.entry_2_id, battles.scored_at
                 FROM battles
                 WHERE battles.scored_at > last_battle_time
                 AND battles.score != 0
                 AND battles.disqualified = 0
                 ORDER BY battles.scored_at limit process_limit LOOP

    -- Calculate K the same as before so we match up with the existing scores we need a 320 multiplier
    -- We better only go through this loop once
    FOR current_phase IN SELECT phases.* from contests join phases on contests.schedule_id=phases.schedule_id and contests.phase_ordinal=phases.ordinal where contests.id=r_battle.contest_id LIMIT 1 LOOP

      cliff_duration := EXTRACT(EPOCH FROM (current_phase.end_time - current_phase.start_time)) * 0.15;
      decline_duration := EXTRACT(EPOCH FROM (current_phase.end_time - current_phase.start_time)) * 0.35;

      start_decline := current_phase.end_time - CAST(decline_duration + cliff_duration || ' seconds' AS INTERVAL);
      start_cliff := current_phase.end_time - CAST(cliff_duration || ' seconds' AS INTERVAL);

      IF r_battle.scored_at < start_decline THEN
        f_k_val := 3200;
      ELSE
        IF r_battle.scored_at < start_cliff THEN
          -- calc k as 100% down 50% of 3200 of the decline
          f_k_val := (((EXTRACT(EPOCH FROM (start_cliff - r_battle.scored_at)) / decline_duration) * 50) + 50) * 32;
        ELSE
          -- calc k as 50% down to 0% of 3200
          f_k_val := ((EXTRACT(EPOCH FROM (current_phase.end_time - r_battle.scored_at)) / cliff_duration) * 50) * 32;
        END IF;
      END IF;
    END LOOP;

    up1 := 0;
    up2 := 0;
    down1 := 0;
    down2 := 0;

    IF r_battle.score < 0 THEN
      increment_1 := CAST(f_k_val AS int);
      increment_2 := -1 * increment_1;
      up1 := 1;
      down2 := 1;
    ELSE
      increment_2 := CAST(f_k_val AS int);
      increment_1 := -1 * increment_2;
      up2 := 1;
      down1 := 1;
    END IF;

    -- entry1
    UPDATE qaos_user_entry_scores SET score = score + increment_1, ups = ups + up1, downs = downs + down1
      WHERE qaos_user_entry_scores.user_id = r_battle.user_id AND qaos_user_entry_scores.entry_id=r_battle.entry_1_id AND qaos_user_entry_scores.contest_id=r_battle.contest_id AND qaos_user_entry_scores.phase=r_battle.battle_type;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
      INSERT INTO qaos_user_entry_scores(user_id, contest_id, entry_id, phase, score, ups, downs) VALUES (r_battle.user_id, r_battle.contest_id, r_battle.entry_1_id, r_battle.battle_type, increment_1, up1, down1);
    END IF;
    -- entry2
    UPDATE qaos_user_entry_scores SET score = score + increment_2, ups = ups + up2, downs = downs + down2
      WHERE qaos_user_entry_scores.user_id = r_battle.user_id AND qaos_user_entry_scores.entry_id=r_battle.entry_2_id AND qaos_user_entry_scores.contest_id=r_battle.contest_id AND qaos_user_entry_scores.phase=r_battle.battle_type;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
      INSERT INTO qaos_user_entry_scores(user_id, contest_id, entry_id, phase, score, ups, downs) VALUES (r_battle.user_id, r_battle.contest_id, r_battle.entry_2_id, r_battle.battle_type, increment_2, up2, down2);
    END IF;
    
    battle_count := battle_count + 1;
    last_battle_time := r_battle.scored_at;
  END LOOP;

  UPDATE qaos_last_battle_processed SET scored_at = last_battle_time;

  RETURN battle_count;

END;
$$
    LANGUAGE plpgsql;


--
-- Name: qaos_rebattle_contest(integer, integer, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION qaos_rebattle_contest(contest_id integer, def_score integer, contest_phase_stop_time timestamp without time zone, run_commit boolean) RETURNS integer
    AS $$
DECLARE
  r_battle RECORD;   -- record read when looping through battle table
  r_entry RECORD;    -- record read when looping through entry table
  increment_1 integer;      -- QAOS score increment for entry 1
  increment_2 integer;      -- QAOS score increment for entry 2
  f_k_val double precision;          -- k value to be used for given battle
  start_decline timestamp;           -- time that k starts to decline
  start_cliff timestamp;             -- time that k falls off the cliff
  min_battle_power double precision;  -- QAOS score increment for entry 2
  
BEGIN
  -- temp table for remembering current entry scores
  DROP TABLE IF EXISTS t_qaos_entry_scores;
  CREATE TEMP TABLE t_qaos_entry_scores(eid integer, score integer, num_battles integer);
  CREATE INDEX t_qaos_entry_scores_pkey ON t_qaos_entry_scores(eid);
  
  start_decline := contest_phase_stop_time - INTERVAL '15 days';
  start_cliff := contest_phase_stop_time - INTERVAL '4 days';
  min_battle_power := (SELECT minimum_battle_power FROM contests WHERE id=contest_id);
  -- #########################################################################
  -- Loop through all valid battles and join in the users new battle power
    FOR r_battle IN SELECT battles.score, battles.entry_1_id, battles.entry_2_id, battles.scored_at, COALESCE(battle_behavior_ratings.rating, 1.0) as rating
                   FROM battles
                   JOIN battle_behavior_ratings ON battle_behavior_ratings.user_id=battles.user_id AND battle_behavior_ratings.contest_id=battles.contest_id AND battle_behavior_ratings.battle_type IS NULL AND battle_behavior_ratings.behavior_class_name = 'BattlePower'
                   WHERE battles.contest_id = contest_id
                   AND battles.battle_type = 0
                   AND battles.score != 0
                   AND battles.disqualified = 0
                   AND battle_behavior_ratings.rating >= min_battle_power LOOP

    -- New method of calculating K factor
    -- in order to have the scores match up with the existing scores we need a 320 multiplier
    IF r_battle.scored_at < start_decline THEN
      f_k_val := 3200;
    ELSE
      IF r_battle.scored_at < start_cliff THEN
        -- (60 seconds * 60 minutes * 24 hours * 11 days / 50) = 19008
        f_k_val := ((EXTRACT(EPOCH FROM (start_cliff - r_battle.scored_at))/19008) + 50)*32;
      ELSE
        -- (60 seconds * 60 minutes * 24 hours * 4days / 50) = 6912
        f_k_val := (EXTRACT(EPOCH FROM (contest_phase_stop_time - r_battle.scored_at))/6912)*32;
      END IF;
    END IF;

    IF r_battle.score < 0 THEN
      increment_1 := CAST(r_battle.rating * f_k_val AS int);
      increment_2 := -1 * increment_1;
    ELSE
      increment_2 := CAST(r_battle.rating * f_k_val AS int);
      increment_1 := -1 * increment_2;
    END IF;

    UPDATE t_qaos_entry_scores
      SET score = score + increment_1, num_battles = num_battles + 1
      WHERE eid = r_battle.entry_1_id;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
      INSERT INTO t_qaos_entry_scores VALUES (r_battle.entry_1_id, def_score + increment_1, 1);
    END IF;
    -- entry2
    UPDATE t_qaos_entry_scores
      SET score = score + increment_2, num_battles = num_battles + 1
      WHERE eid = r_battle.entry_2_id;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
      INSERT INTO t_qaos_entry_scores VALUES (r_battle.entry_2_id, def_score + increment_2, 1);
    END IF;
  END LOOP;

  -- Loop to set scores for entries
  IF run_commit THEN
    FOR r_entry IN SELECT * from t_qaos_entry_scores LOOP
        UPDATE entries 
          SET score = r_entry.score + COALESCE(score_adjustment, 0), num_battles = r_entry.num_battles
          WHERE entries.id = r_entry.eid and (score != r_entry.score OR num_battles != r_entry.num_battles);
    END LOOP;
  END IF;

  RETURN 0;
END;
$$
    LANGUAGE plpgsql;


--
-- Name: qaos_rebattle_contest(integer, integer, integer, timestamp without time zone, integer, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION qaos_rebattle_contest(contest_id integer, def_score integer, battle_type integer, contest_phase_stop_time timestamp without time zone, decline_duration integer, cliff_duration integer, run_commit boolean) RETURNS integer
    AS $$
DECLARE
  r_battle RECORD;   -- record read when looping through battle table
  r_entry RECORD;    -- record read when looping through entry table
  increment_1 integer;      -- QAOS score increment for entry 1
  increment_2 integer;      -- QAOS score increment for entry 2
  f_k_val double precision;          -- k value to be used for given battle
  start_decline timestamp;           -- time that k starts to decline
  start_cliff timestamp;             -- time that k falls off the cliff
  min_battle_power double precision;  -- QAOS score increment for entry 2
  
BEGIN
  -- temp table for remembering current entry scores
  DROP TABLE IF EXISTS t_qaos_entry_scores;
  CREATE TEMP TABLE t_qaos_entry_scores(eid integer, score integer, num_battles integer);
  CREATE INDEX t_qaos_entry_scores_pkey ON t_qaos_entry_scores(eid);

  start_decline := contest_phase_stop_time - CAST(decline_duration + cliff_duration || ' seconds' AS INTERVAL);
  start_cliff := contest_phase_stop_time - CAST(cliff_duration || ' seconds' AS INTERVAL);
  min_battle_power := (SELECT minimum_battle_power FROM contests WHERE id=contest_id);
  -- #########################################################################
  -- Loop through all valid battles and join in the users new battle power
    FOR r_battle IN SELECT battles.score, battles.entry_1_id, battles.entry_2_id, battles.scored_at, COALESCE(battle_behavior_ratings.rating, 1.0) as rating
                   FROM battles
                   JOIN battle_behavior_ratings ON battle_behavior_ratings.user_id=battles.user_id AND battle_behavior_ratings.contest_id=battles.contest_id AND battle_behavior_ratings.behavior_class_name = 'BattlePower'
                   WHERE battles.contest_id = contest_id
                   AND battles.battle_type = battle_type
                   AND battles.score != 0
                   AND battles.disqualified = 0
                   AND battle_behavior_ratings.rating >= min_battle_power LOOP

    -- New method of calculating K factor
    -- in order to have the scores match up with the existing scores we need a 320 multiplier
    IF r_battle.scored_at < start_decline THEN
      f_k_val := 3200;
    ELSE
      IF r_battle.scored_at < start_cliff THEN
        -- calc k as 100% down 50% of 3200 of the decline
        f_k_val := (((EXTRACT(EPOCH FROM (start_cliff - r_battle.scored_at)) / decline_duration) * 50) + 50) * 32;
      ELSE
        -- calc k as 50% down to 0% of 3200
        f_k_val := ((EXTRACT(EPOCH FROM (contest_phase_stop_time - r_battle.scored_at)) / cliff_duration) * 50) * 32;
      END IF;
    END IF;

    IF r_battle.score < 0 THEN
      increment_1 := CAST(r_battle.rating * f_k_val AS int);
      increment_2 := -1 * increment_1;
    ELSE
      increment_2 := CAST(r_battle.rating * f_k_val AS int);
      increment_1 := -1 * increment_2;
    END IF;

    UPDATE t_qaos_entry_scores
      SET score = score + increment_1, num_battles = num_battles + 1
      WHERE eid = r_battle.entry_1_id;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
      INSERT INTO t_qaos_entry_scores VALUES (r_battle.entry_1_id, def_score + increment_1, 1);
    END IF;
    -- entry2
    UPDATE t_qaos_entry_scores
      SET score = score + increment_2, num_battles = num_battles + 1
      WHERE eid = r_battle.entry_2_id;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
      INSERT INTO t_qaos_entry_scores VALUES (r_battle.entry_2_id, def_score + increment_2, 1);
    END IF;
  END LOOP;

  -- Loop to set scores for entries
  IF run_commit THEN
    FOR r_entry IN SELECT * from t_qaos_entry_scores LOOP
        UPDATE entries 
          SET score = r_entry.score + COALESCE(score_adjustment, 0), num_battles = r_entry.num_battles
          WHERE entries.id = r_entry.eid and (score != r_entry.score OR num_battles != r_entry.num_battles);
    END LOOP;
  END IF;

  RETURN 0;
END;
$$
    LANGUAGE plpgsql;


--
-- Name: qaos_reprocess_contest(integer, integer, timestamp without time zone, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION qaos_reprocess_contest(the_contest_id integer, the_phase integer, contest_phase_stop_time timestamp without time zone, decline_duration integer, cliff_duration integer) RETURNS integer
    AS $$
DECLARE
  r_battle RECORD;   -- record read when looping through battle table
  increment_1 integer;      -- QAOS score increment for entry 1
  increment_2 integer;      -- QAOS score increment for entry 2
  f_k_val double precision;          -- k value to be used for given battle
  start_decline timestamp;           -- time that k starts to decline
  start_cliff timestamp;             -- time that k falls off the cliff
  last_battle_time timestamp;
  battle_count integer;
  up1 integer;
  up2 integer;
  down1 integer;
  down2 integer;

BEGIN

  battle_count := 0;
  
  DELETE FROM qaos_user_entry_scores WHERE qaos_user_entry_scores.contest_id = the_contest_id AND qaos_user_entry_scores.phase = the_phase;
  last_battle_time := (SELECT scored_at from qaos_last_battle_processed);
  
  start_decline := contest_phase_stop_time - CAST(decline_duration + cliff_duration || ' seconds' AS INTERVAL);
  start_cliff := contest_phase_stop_time - CAST(cliff_duration || ' seconds' AS INTERVAL);

  FOR r_battle IN SELECT battles.id, battles.user_id, battles.contest_id, battles.battle_type, battles.score, battles.entry_1_id, battles.entry_2_id, battles.scored_at
                 FROM battles
                 WHERE battles.contest_id = the_contest_id
                 AND battles.scored_at <= last_battle_time
                 AND battles.battle_type = the_phase
                 AND battles.score != 0
                 AND battles.disqualified = 0
                 ORDER BY scored_at LOOP

    -- Calculate K the same as before so we match up with the existing scores we need a 320 multiplier
    IF r_battle.scored_at < start_decline THEN
      f_k_val := 3200;
    ELSE
      IF r_battle.scored_at < start_cliff THEN
        -- calc k as 100% down 50% of 3200 of the decline
        f_k_val := (((EXTRACT(EPOCH FROM (start_cliff - r_battle.scored_at)) / decline_duration) * 50) + 50) * 32;
      ELSE
        -- calc k as 50% down to 0% of 3200
        f_k_val := ((EXTRACT(EPOCH FROM (contest_phase_stop_time - r_battle.scored_at)) / cliff_duration) * 50) * 32;
      END IF;
    END IF;

    up1 := 0;
    up2 := 0;
    down1 := 0;
    down2 := 0;

    IF r_battle.score < 0 THEN
      increment_1 := CAST(f_k_val AS int);
      increment_2 := -1 * increment_1;
      up1 := 1;
      down2 := 1;
    ELSE
      increment_2 := CAST(f_k_val AS int);
      increment_1 := -1 * increment_2;
      up2 := 1;
      down1 := 1;
    END IF;

    -- entry1
    UPDATE qaos_user_entry_scores SET score = score + increment_1, ups = ups + up1, downs = downs + down1
      WHERE qaos_user_entry_scores.user_id = r_battle.user_id AND qaos_user_entry_scores.entry_id=r_battle.entry_1_id AND qaos_user_entry_scores.contest_id=r_battle.contest_id AND qaos_user_entry_scores.phase=r_battle.battle_type;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
      INSERT INTO qaos_user_entry_scores(user_id, contest_id, entry_id, phase, score, ups, downs) VALUES (r_battle.user_id, r_battle.contest_id, r_battle.entry_1_id, r_battle.battle_type, increment_1, up1, down1);
    END IF;
    -- entry2
    UPDATE qaos_user_entry_scores SET score = score + increment_2, ups = ups + up2, downs = downs + down2
      WHERE qaos_user_entry_scores.user_id = r_battle.user_id AND qaos_user_entry_scores.entry_id=r_battle.entry_2_id AND qaos_user_entry_scores.contest_id=r_battle.contest_id AND qaos_user_entry_scores.phase=r_battle.battle_type;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
      INSERT INTO qaos_user_entry_scores(user_id, contest_id, entry_id, phase, score, ups, downs) VALUES (r_battle.user_id, r_battle.contest_id, r_battle.entry_2_id, r_battle.battle_type, increment_2, up2, down2);
    END IF;
    
    battle_count := battle_count + 1;
  END LOOP;

  RETURN battle_count;

END;
$$
    LANGUAGE plpgsql;


--
-- Name: qaos_reprocess_contest(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION qaos_reprocess_contest(_contest integer, _phase integer) RETURNS integer
    AS $$
DECLARE
  r_battle RECORD;   -- record read when looping through battle table
  f_k_val double precision;          -- k value to be used for given battle

  start_decline timestamp;           -- time that k starts to decline
  decline_duration integer;
  start_cliff timestamp;             -- time that k falls off the cliff
  cliff_duration integer;

  last_battle_time timestamp;

  phase_start_time timestamp;             -- time that k falls off the cliff
  phase_end_time timestamp;               -- time that k falls off the cliff

  battle_count integer;

  increment_1 integer;      -- QAOS score increment for entry 1
  increment_2 integer;      -- QAOS score increment for entry 2
  up1 integer;
  up2 integer;
  down1 integer;
  down2 integer;

BEGIN

  battle_count := 0;
  last_battle_time := (SELECT scored_at from qaos_last_battle_processed);

  -- Delete all of the accumulated user entry scores for the given phase
  DELETE FROM qaos_user_entry_scores WHERE qaos_user_entry_scores.contest_id = _contest AND qaos_user_entry_scores.phase = _phase;

  -- Get the vitals for this contest phase
  SELECT phases.start_time, phases.end_time INTO phase_start_time, phase_end_time
  FROM phases JOIN contests ON contests.schedule_id=phases.schedule_id AND contests.phase_ordinal=phases.ordinal
  WHERE contests.id = _contest;

  FOR r_battle IN SELECT battles.user_id, battles.contest_id, battles.battle_type, battles.score, battles.entry_1_id, battles.entry_2_id, battles.scored_at
                 FROM battles
                 WHERE battles.contest_id = _contest
                 AND battles.scored_at <= last_battle_time
                 AND battles.battle_type = _phase
                 AND battles.score != 0
                 AND battles.disqualified = 0
                 ORDER BY battles.scored_at LOOP

    -- Calculate K the same as before so we match up with the existing scores we need a 320 multiplier

    cliff_duration := EXTRACT(EPOCH FROM (phase_end_time - phase_start_time)) * 0.15;
    decline_duration := EXTRACT(EPOCH FROM (phase_end_time - phase_start_time)) * 0.35;
    start_decline := phase_end_time - CAST(decline_duration + cliff_duration || ' seconds' AS INTERVAL);
    start_cliff := phase_end_time - CAST(cliff_duration || ' seconds' AS INTERVAL);

    IF r_battle.scored_at < start_decline THEN
      f_k_val := 3200;
    ELSE
      IF r_battle.scored_at < start_cliff THEN
        -- calc k as 100% down 50% of 3200 of the decline
        f_k_val := (((EXTRACT(EPOCH FROM (start_cliff - r_battle.scored_at)) / decline_duration) * 50) + 50) * 32;
      ELSE
        -- calc k as 50% down to 0% of 3200
        f_k_val := ((EXTRACT(EPOCH FROM (phase_end_time - r_battle.scored_at)) / cliff_duration) * 50) * 32;
      END IF;
    END IF;

    up1 := 0;
    up2 := 0;
    down1 := 0;
    down2 := 0;

    IF r_battle.score < 0 THEN
      increment_1 := CAST(f_k_val AS int);
      increment_2 := -1 * increment_1;
      up1 := 1;
      down2 := 1;
    ELSE
      increment_2 := CAST(f_k_val AS int);
      increment_1 := -1 * increment_2;
      up2 := 1;
      down1 := 1;
    END IF;

    IF r_battle.score <> 0 THEN
      -- entry1
      UPDATE qaos_user_entry_scores SET score = score + increment_1, ups = ups + up1, downs = downs + down1
        WHERE qaos_user_entry_scores.user_id = r_battle.user_id AND qaos_user_entry_scores.entry_id=r_battle.entry_1_id AND qaos_user_entry_scores.contest_id=r_battle.contest_id AND qaos_user_entry_scores.phase=r_battle.battle_type;
      IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
        INSERT INTO qaos_user_entry_scores("user_id", "contest_id", "entry_id", "phase", "score", "ups", "downs") VALUES (r_battle.user_id, r_battle.contest_id, r_battle.entry_1_id, r_battle.battle_type, increment_1, up1, down1);
      END IF;
      -- entry2
      UPDATE qaos_user_entry_scores SET score = score + increment_2, ups = ups + up2, downs = downs + down2
        WHERE qaos_user_entry_scores.user_id = r_battle.user_id AND qaos_user_entry_scores.entry_id=r_battle.entry_2_id AND qaos_user_entry_scores.contest_id=r_battle.contest_id AND qaos_user_entry_scores.phase=r_battle.battle_type;
      IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
        INSERT INTO qaos_user_entry_scores("user_id", "contest_id", "entry_id", "phase", "score", "ups", "downs") VALUES (r_battle.user_id, r_battle.contest_id, r_battle.entry_2_id, r_battle.battle_type, increment_2, up2, down2);
      END IF;
    END IF;

    battle_count := battle_count + 1;

  END LOOP;

  RETURN battle_count;

END;
$$
    LANGUAGE plpgsql;


--
-- Name: qaos_rescore_entries(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION qaos_rescore_entries(the_contest_id integer) RETURNS integer
    AS $$
DECLARE
  r_entry_scores RECORD;   -- record read when looping through battle table
  entries_updated integer;
  minimum_battle_power real;

BEGIN

  DELETE FROM qaos_temp_entries;

  entries_updated := 0;
  minimum_battle_power := (SELECT contests."minimum_battle_power" from contests where id= the_contest_id);

  FOR r_entry_scores IN SELECT qaos_user_entry_scores.contest_id, qaos_user_entry_scores.entry_id, SUM(qaos_user_entry_scores.score * COALESCE(battle_behavior_ratings.rating, 1.0)) as score, SUM(ups) as ups, SUM(downs) as downs
    FROM qaos_user_entry_scores 
    JOIN battle_behavior_ratings ON qaos_user_entry_scores.contest_id=battle_behavior_ratings.contest_id AND qaos_user_entry_scores.user_id=battle_behavior_ratings.user_id 
    WHERE battle_behavior_ratings.behavior_class_name = 'BattlePower' AND qaos_user_entry_scores.contest_id = the_contest_id AND battle_behavior_ratings.rating > minimum_battle_power
    GROUP BY qaos_user_entry_scores.contest_id, qaos_user_entry_scores.entry_id LOOP

--    UPDATE qaos_temp_entries
--      SET score = 1500000 + r_entry_scores.score + COALESCE(qaos_temp_entries.score_adjustment, 0), num_battles = r_entry_scores.ups + r_entry_scores.downs
--      WHERE qaos_temp_entries.entry_id = r_entry_scores.entry_id;
--    IF NOT FOUND THEN
      INSERT INTO qaos_temp_entries("entry_id", "contest_id", "score_adjustment") (SELECT "id", "contest_id", "score_adjustment" FROM entries WHERE id = r_entry_scores.entry_id);
      UPDATE qaos_temp_entries
        SET score = 1500000 + r_entry_scores.score + COALESCE(qaos_temp_entries.score_adjustment, 0), num_battles = r_entry_scores.ups + r_entry_scores.downs
        WHERE qaos_temp_entries.entry_id = r_entry_scores.entry_id;
--    END IF;
    
    entries_updated := entries_updated + 1;
  END LOOP;

  RETURN entries_updated;

END;
$$
    LANGUAGE plpgsql;


--
-- Name: qaos_rescore_entries(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION qaos_rescore_entries(the_contest_id integer, the_phase integer, the_battle_type integer) RETURNS integer
    AS $$
DECLARE
  r_entry_scores RECORD;   -- record read when looping through battle table
  entries_updated integer;
  minimum_battle_power real;
  battle_type integer;
BEGIN

  battle_type := 0;
  entries_updated := 0;
  minimum_battle_power := (SELECT contests."minimum_battle_power" from contests where id= the_contest_id);

  FOR r_entry_scores IN SELECT qaos_user_entry_scores.contest_id, qaos_user_entry_scores.entry_id, SUM(qaos_user_entry_scores.score * COALESCE(battle_behavior_ratings.rating, 0.0)) as score, SUM(ups) as ups, SUM(downs) as downs
    FROM qaos_user_entry_scores 
    JOIN battle_behavior_ratings ON qaos_user_entry_scores.contest_id=battle_behavior_ratings.contest_id AND qaos_user_entry_scores.user_id=battle_behavior_ratings.user_id 
    WHERE battle_behavior_ratings.behavior_class_name = 'BattlePower' AND qaos_user_entry_scores.contest_id = the_contest_id AND qaos_user_entry_scores.phase = the_battle_type AND battle_behavior_ratings.rating >= minimum_battle_power
    GROUP BY qaos_user_entry_scores.contest_id, qaos_user_entry_scores.entry_id LOOP

    UPDATE entries
      SET score = 1500000 + r_entry_scores.score + COALESCE(entries.score_adjustment, 0), num_battles = r_entry_scores.ups + r_entry_scores.downs
      WHERE entries.id = r_entry_scores.entry_id AND entries.phase = the_phase AND entries.disqualified=0 and entries.score != 1500000 + r_entry_scores.score + COALESCE(entries.score_adjustment, 0) AND entries.num_battles != r_entry_scores.ups + r_entry_scores.downs;

    entries_updated := entries_updated + 1;
  END LOOP;

  RETURN entries_updated;

END;
$$
    LANGUAGE plpgsql;


--
-- Name: qaos_rescore_entries(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION qaos_rescore_entries(the_contest_id integer, the_phase integer) RETURNS integer
    AS $$
DECLARE
  r_entry_scores RECORD;   -- record read when looping through battle table
  entries_updated integer;
  minimum_battle_power real;
BEGIN

  entries_updated := 0;
  minimum_battle_power := (SELECT contests."minimum_battle_power" from contests where id= the_contest_id);

  FOR r_entry_scores IN SELECT qaos_user_entry_scores.contest_id, qaos_user_entry_scores.entry_id, SUM(qaos_user_entry_scores.score * COALESCE(battle_behavior_ratings.rating, 0.0)) as score, SUM(ups) as ups, SUM(downs) as downs
    FROM qaos_user_entry_scores 
    JOIN battle_behavior_ratings ON qaos_user_entry_scores.contest_id=battle_behavior_ratings.contest_id AND qaos_user_entry_scores.user_id=battle_behavior_ratings.user_id 
    WHERE battle_behavior_ratings.behavior_class_name = 'BattlePower' AND qaos_user_entry_scores.contest_id = the_contest_id AND qaos_user_entry_scores.phase = the_phase AND battle_behavior_ratings.rating >= minimum_battle_power
    GROUP BY qaos_user_entry_scores.contest_id, qaos_user_entry_scores.entry_id LOOP

    UPDATE entries
      SET score = 1500000 + r_entry_scores.score + COALESCE(entries.score_adjustment, 0), num_battles = r_entry_scores.ups + r_entry_scores.downs
      WHERE entries.id = r_entry_scores.entry_id AND entries.phase = the_phase AND entries.disqualified=0 and entries.score != 1500000 + r_entry_scores.score + COALESCE(entries.score_adjustment, 0) AND entries.num_battles != r_entry_scores.ups + r_entry_scores.downs;

    entries_updated := entries_updated + 1;
  END LOOP;

  RETURN entries_updated;

END;
$$
    LANGUAGE plpgsql;


--
-- Name: rebattle_contest(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rebattle_contest(c_id integer) RETURNS integer[]
    AS $$
DECLARE
  f_idx1 int;        -- index counter for temp entry table: entry 1
  f_idx2 int;        -- index counter for temp entry table: entry 2
  f_battle_ct int;   -- counts # battles processed
  f_entry_ct int;    -- counts # entries processed
  r_battle RECORD;   -- record read when looping through battle table
  r_entry RECORD;    -- record read when looping through entry table
  f_num_battles int; -- number of countable battles an entry has had
  score_1 int;       -- current entry 1 score at time of battle
  score_2 int;       -- current entry 2 score at time of battle
  expected_score_1 double precision; -- ELO expected score for entry 1
  expected_score_2 double precision; -- ELO expected score for entry 2
  increment_1 double precision;      -- ELO score increment for entry 1
  increment_2 double precision;      -- ELO score increment for entry 2
  f_new_entry_1_score integer;       -- ELO new score for entry 1
  f_new_entry_2_score integer;       -- ELO new score for entry 2
  f_k_val double precision;          -- ELO k value to be used for given battle
  f_potency double precision;        -- battle power for user doing a battle
BEGIN
  -- initialize defaults, counters and indexes
  f_idx1        := 1;
  f_idx2        := 2;
  f_battle_ct   := 0;
  f_entry_ct    := 0;
  f_potency     := 0.0;

  -- temp table for remembering entry ranks 
  -- (new record for each changel I control indexing using f_idx1 and f_idx2)
  CREATE TEMP TABLE t_entry_ranks (
    tid integer ,
    eid integer ,
    score integer
    ) ON COMMIT DROP;
    CREATE INDEX t_entry_ranks_pkey ON t_entry_ranks (tid DESC);

  -- #########################################################################
  -- Loop through all valid battles
  FOR r_battle IN SELECT * FROM battles 
                   WHERE battles.contest_id = c_id
                     AND battles.battle_type = 0
                     AND battles.new_entry_1_score > 0 
                     AND (battles.disqualified = 0 OR battles.disqualified IS NULL)
                   ORDER BY battles.scored_at LOOP

    -- look up latest entry 1 score in a temp-table cached way
       SELECT t_entry_ranks.score INTO score_1
         FROM t_entry_ranks
        WHERE t_entry_ranks.eid = r_battle.entry_1_id
     ORDER BY t_entry_ranks.tid DESC
        LIMIT 1;
    IF score_1 IS NULL THEN
      SELECT entries.score INTO score_1
        FROM entries
       WHERE entries.id = r_battle.entry_1_id;
    END IF;

    -- look up latest entry 2 score in a temp-table cached way
      SELECT t_entry_ranks.score INTO score_2
        FROM t_entry_ranks
       WHERE t_entry_ranks.eid = r_battle.entry_2_id
    ORDER BY t_entry_ranks.tid DESC
       LIMIT 1;
    IF score_2 IS NULL THEN
      SELECT entries.score INTO score_2
        FROM entries
       WHERE entries.id = r_battle.entry_2_id;
    END IF;

    -- potency only matters if score is not 0
    IF r_battle.score = 0 THEN
      -- no-pref battle; scores do not change, don't bother looking up new battle power
      f_new_entry_1_score := score_1;
      f_new_entry_2_score := score_2;
      f_potency           := r_battle.battle_power;
    ELSE
      -- Look up current potency for user in current battle
      SELECT rating INTO f_potency
        FROM battle_behavior_ratings
       WHERE battle_type IS NULL 
         AND behavior_class_name = 'BattlePower'
         AND user_id    = r_battle.user_id
         AND contest_id = r_battle.contest_id
       LIMIT 1;
      
      IF f_potency IS NULL THEN
        f_potency := 1.0;
      END IF;
      -- f_potency := r_battle.battle_power; -- Test code to verify same as rails

      -- ELO calculation of score changes (unless potency would nullify it anyway)
      IF f_potency > 0 THEN
        f_k_val          := (32.0 - ((date_part('day',r_battle.scored_at) - 1.0) * 0.7619))*1000;
        expected_score_1 := 1.0/(1+ 10^((score_2 - score_1)*0.0000025));
        expected_score_2 := 1.0/(1+ 10^((score_1 - score_2)*0.0000025));
        if r_battle.score < 0 THEN
          increment_1 := f_k_val * (1 - expected_score_1) * f_potency;
          increment_2 := f_k_val * (0 - expected_score_2) * f_potency;
        ELSE
          increment_1 := f_k_val * (0 - expected_score_1) * f_potency;
          increment_2 := f_k_val * (1 - expected_score_2) * f_potency;
        END IF;

        f_new_entry_1_score := score_1 + CAST(increment_1 AS int);
        f_new_entry_2_score := score_2 + CAST(increment_2 AS int);

        -- insert new values into score caching table
        INSERT INTO t_entry_ranks (tid,eid,score)
        VALUES (f_idx1,r_battle.entry_1_id, f_new_entry_1_score), 
               (f_idx2,r_battle.entry_2_id, f_new_entry_2_score);
        f_idx1 := f_idx2 + 1; -- increment by 2
        f_idx2 := f_idx1 + 1; -- increment by 2
      ELSE
        -- impotent battler: scores do not change
        f_new_entry_1_score := score_1;
        f_new_entry_2_score := score_2;
      END IF;
    END IF;

    -- update battle table
    UPDATE battles
       SET new_entry_1_score = f_new_entry_1_score,
           new_entry_2_score = f_new_entry_2_score,
           battle_power = f_potency
     WHERE battles.id = r_battle.id;

    -- increment loop counter
    f_battle_ct := f_battle_ct + 1;
  END LOOP;
  -- #########################################################################
  -- Loop to set scores for entries
  FOR r_entry IN SELECT * from entries
                  WHERE entries.contest_id   = c_id 
                    AND entries.disqualified = 0
                    AND entries.withdrawn    = 0 LOOP

    -- Get last calculated score for the entry
       SELECT t_entry_ranks.score INTO score_1
         FROM t_entry_ranks
        WHERE t_entry_ranks.eid = r_entry.id
     ORDER BY t_entry_ranks.tid DESC
        LIMIT 1;

    -- score does not change if no score-changing battles were processed
    IF score_1 IS NULL THEN
      score_1       := r_entry.score;
      f_num_battles := 0;
    ELSE
      -- num battles is the the number of entries stored in temp table
      SELECT COUNT(eid) INTO f_num_battles
        FROM t_entry_ranks
       WHERE t_entry_ranks.eid = r_entry.id;
    END IF;

    UPDATE entries 
       SET score       = score_1,
           num_battles = f_num_battles
     WHERE entries.id  = r_entry.id;

    f_entry_ct := f_entry_ct + 1;
  END LOOP;

  RETURN ARRAY[f_battle_ct,f_entry_ct];
END;
$$
    LANGUAGE plpgsql;


--
-- Name: rebattle_contest(integer, integer, integer, boolean, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rebattle_contest(contest_id integer, def_score integer, run_limit integer, run_commit boolean, use_latest_battle_power boolean) RETURNS integer[]
    AS $$
DECLARE
  f_battle_ct int;   -- counts # battles processed
  f_entry_ct int;    -- counts # entries processed
  r_battle RECORD;   -- record read when looping through battle table
  r_entry RECORD;    -- record read when looping through entry table
  f_num_battles int; -- number of countable battles an entry has had
  score_1 int;       -- current entry 1 score at time of battle
  score_2 int;       -- current entry 2 score at time of battle
  expected_score_1 double precision; -- ELO expected score for entry 1
  expected_score_2 double precision; -- ELO expected score for entry 2
  increment_1 double precision;      -- ELO score increment for entry 1
  increment_2 double precision;      -- ELO score increment for entry 2
  f_new_entry_1_score integer;       -- ELO new score for entry 1
  f_new_entry_2_score integer;       -- ELO new score for entry 2
  f_k_val double precision;          -- ELO k value to be used for given battle
  f_potency double precision;        -- battle power for user doing a battle
  entry_id integer;
BEGIN
  -- initialize defaults, counters and indexes
  f_battle_ct   := 0;
  f_entry_ct    := 0;
  -- temp table for remembering current entry scores
  DROP TABLE IF EXISTS t_entry_scores;
  CREATE TEMP TABLE t_entry_scores(eid integer, score integer, num_battles integer);
  CREATE INDEX t_entry_scores_pkey ON t_entry_scores(eid);
  
  -- IF run_commit THEN
  --  RAISE NOTICE 'Run and COMMIT changes';
  -- ELSE
  --  RAISE NOTICE 'Run and DO NOT COMMIT changes';
  -- END IF;
  
  -- #########################################################################
  -- Loop through all valid battles
  FOR r_battle IN SELECT * FROM battles 
                   WHERE battles.contest_id = contest_id
                     AND battles.battle_type = 0
                     AND (battles.disqualified = 0 OR battles.disqualified IS NULL)
                   ORDER BY battles.scored_at, battles.id LIMIT run_limit LOOP

    -- look up latest entry 1 score from the temp table
    SELECT score INTO score_1 FROM t_entry_scores WHERE t_entry_scores.eid = r_battle.entry_1_id LIMIT 1;
    IF score_1 IS NULL THEN
      score_1 := def_score;
    END IF;
    -- look up latest entry 2 score from the temp table
    SELECT score INTO score_2 FROM t_entry_scores WHERE t_entry_scores.eid = r_battle.entry_2_id LIMIT 1;
    IF score_2 IS NULL THEN
      score_2 := def_score;
    END IF;
    -- Set scores to current value for no-pref or no battle power, and NULL for disqualified battles
    IF r_battle.score = 0 OR r_battle.battle_power = 0 OR r_battle.disqualified != 0 THEN
      IF r_battle.disqualified != 0 THEN
        f_new_entry_1_score := NULL;
        f_new_entry_2_score := NULL;
      ELSE
        f_new_entry_1_score := score_1;
        f_new_entry_2_score := score_2;
      END IF;
    ELSE
      -- This is where the battle counted
      -- Note: this assumes contests start and stop on month boundaries
      f_k_val          := (32.0 - ((date_part('day',r_battle.scored_at) - 1.0) * 0.7619)) * 1000; 
      expected_score_1 := 1.0/(1+ 10^((score_2 - score_1)*0.0000025));
      expected_score_2 := 1.0/(1+ 10^((score_1 - score_2)*0.0000025));
      
      IF use_latest_battle_power THEN
        SELECT rating INTO f_potency
          FROM battle_behavior_ratings
         WHERE battle_type IS NULL 
           AND behavior_class_name = 'BattlePower'
           AND user_id    = r_battle.user_id
           AND contest_id = r_battle.contest_id
          ORDER BY id
         LIMIT 1;
      ELSE      -- get potency from battle
        f_potency := r_battle.battle_power;
      END IF;
      
      IF f_potency IS NULL THEN
        f_potency := 1.0;
      END IF;

      IF r_battle.score < 0 THEN
        increment_1 := f_k_val * (1 - expected_score_1) * f_potency;
        increment_2 := f_k_val * (0 - expected_score_2) * f_potency;
      ELSE
        increment_1 := f_k_val * (0 - expected_score_1) * f_potency;
        increment_2 := f_k_val * (1 - expected_score_2) * f_potency;
      END IF;

      f_new_entry_1_score := score_1 + CAST(increment_1 AS int);
      f_new_entry_2_score := score_2 + CAST(increment_2 AS int);
    END IF;

    UPDATE t_entry_scores
      SET score = f_new_entry_1_score, num_battles = num_battles + 1
      WHERE eid = r_battle.entry_1_id;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
      INSERT INTO t_entry_scores VALUES (r_battle.entry_1_id, f_new_entry_1_score, 1);
    END IF;
    -- entry2
    UPDATE t_entry_scores
      SET score = f_new_entry_2_score, num_battles = num_battles + 1
      WHERE eid = r_battle.entry_2_id;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records where updated
      INSERT INTO t_entry_scores VALUES (r_battle.entry_2_id, f_new_entry_2_score, 1);
    END IF;

    -- Only update battles where the scores have actually changed
    -- Test with tolerance of 2 for potential rounding differences with ruby
    IF ABS(f_new_entry_1_score - r_battle.new_entry_1_score) > 2 OR ABS(f_new_entry_2_score - r_battle.new_entry_2_score) > 2 THEN
      -- RAISE NOTICE 'UPDATED battle % rating % entry1 % entry2 % base1 % base2 % oldscore1 % oldscore2 % newscore1 % newscore2 % k-value % potency %',
      --   r_battle.id, r_battle.score, r_battle.entry_1_id, r_battle.entry_2_id, score_1, score_2, r_battle.new_entry_1_score, r_battle.new_entry_2_score, f_new_entry_1_score, f_new_entry_2_score, f_k_val, f_potency;
      
      f_battle_ct := f_battle_ct + 1;
      -- update battle table
      IF run_commit THEN
          UPDATE battles
          SET new_entry_1_score = f_new_entry_1_score,
              new_entry_2_score = f_new_entry_2_score
          WHERE battles.id = r_battle.id;
      END IF;
    ELSE
      -- RAISE NOTICE 'SKIPPED battle % rating % entry1 % entry2 % base1 % base2 % newscore1 % newscore2 %',
      --   r_battle.id, r_battle.score, r_battle.entry_1_id, r_battle.entry_2_id, score_1, score_2, f_new_entry_1_score, f_new_entry_2_score;
      END IF;
  END LOOP;
  
  -- Loop to set scores for entries
  FOR r_entry IN SELECT * from t_entry_scores LOOP
    FOUND := FALSE;
    IF run_commit THEN
      UPDATE entries 
        SET score = r_entry.score, num_battles = r_entry.num_battles
        WHERE entries.id = r_entry.eid and (score != r_entry.score OR num_battles != r_entry.num_battles);
    ELSE
      SELECT id INTO entry_id FROM entries WHERE entries.id = r_entry.eid and (score != r_entry.score OR num_battles != r_entry.num_battles);
      IF entry_id IS NOT NULL THEN
        FOUND := TRUE;
      END IF;
    END IF;
    
    IF FOUND THEN
      f_entry_ct := f_entry_ct + 1;
  --   RAISE NOTICE 'UPDATE entry % score % battles %', r_entry.eid, r_entry.score, r_entry.num_battles;
  -- ELSE
  --   RAISE NOTICE 'SKIP entry % score % battles %', r_entry.eid, r_entry.score, r_entry.num_battles;
    END IF;
  END LOOP;

  RETURN ARRAY[f_battle_ct, f_entry_ct];
END;
$$
    LANGUAGE plpgsql;


--
-- Name: rebattle_contest(integer, integer, timestamp without time zone, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rebattle_contest(contest_id integer, def_score integer, contest_phase_stop_time timestamp without time zone, run_commit boolean) RETURNS integer
    AS $$
DECLARE
  r_battle RECORD;   -- record read when looping through battle table
  r_entry RECORD;    -- record read when looping through entry table
  score_1 int;       -- current entry 1 score at time of battle
  score_2 int;       -- current entry 2 score at time of battle
  expected_score_1 double precision; -- ELO expected score for entry 1
  expected_score_2 double precision; -- ELO expected score for entry 2
  increment_1 double precision;      -- ELO score increment for entry 1
  increment_2 double precision;      -- ELO score increment for entry 2
  f_new_entry_1_score integer;       -- ELO new score for entry 1
  f_new_entry_2_score integer;       -- ELO new score for entry 2
  f_k_val double precision;          -- k value to be used for given battle
BEGIN
  -- temp table for current entry scores
  DROP TABLE IF EXISTS t_entry_scores;
  CREATE TEMP TABLE t_entry_scores(eid integer, score integer, num_battles integer);
  CREATE INDEX t_entry_scores_pkey ON t_entry_scores(eid);
  -- #########################################################################
  -- Loop through all valid battles
  FOR r_battle IN SELECT battles.score, battles.entry_1_id, battles.entry_2_id, battles.scored_at, COALESCE(battle_behavior_ratings.rating, 1.0) as rating
               FROM battles
               JOIN battle_behavior_ratings ON battle_behavior_ratings.user_id=battles.user_id AND battle_behavior_ratings.contest_id=battles.contest_id AND battle_behavior_ratings.battle_type IS NULL AND battle_behavior_ratings.behavior_class_name = 'BattlePower'
               WHERE battles.contest_id = contest_id
               AND battles.battle_type = 0
               AND battles.score != 0
               AND battles.disqualified = 0
               AND battle_behavior_ratings.rating > 0
               ORDER BY battles.scored_at, battles.id LOOP

    -- look up latest entry 1 score from the temp table
    SELECT score INTO score_1 FROM t_entry_scores WHERE t_entry_scores.eid = r_battle.entry_1_id LIMIT 1;
    IF score_1 IS NULL THEN
      score_1 := def_score;
    END IF;
    -- look up latest entry 2 score from the temp table
    SELECT score INTO score_2 FROM t_entry_scores WHERE t_entry_scores.eid = r_battle.entry_2_id LIMIT 1;
    IF score_2 IS NULL THEN
      score_2 := def_score;
    END IF;
    -- New method of calculating K factor
    -- in order to have the scores match up with the existing scores we need a 320 multiplier
    IF contest_phase_stop_time - r_battle.scored_at > INTERVAL '15 days' THEN
      f_k_val := 32000;
    ELSE
      IF contest_phase_stop_time - r_battle.scored_at > INTERVAL '4 days' THEN
        -- (60 seconds * 60 minutes * 24 hours * 11 days / 50) = 19008
        f_k_val := ((EXTRACT(EPOCH FROM (contest_phase_stop_time - INTERVAL '96 hours' - r_battle.scored_at))/19008) + 50)*320;
      ELSE
        -- (60 seconds * 60 minutes * 24 hours * 4days / 50) = 6912
        f_k_val := (EXTRACT(EPOCH FROM (contest_phase_stop_time - r_battle.scored_at))/6912)*320;
      END IF;
    END IF;
    
    expected_score_1 := 1.0/(1+ 10^((score_2 - score_1)*0.0000025));
    expected_score_2 := 1.0/(1+ 10^((score_1 - score_2)*0.0000025));

    IF r_battle.score < 0 THEN
      increment_1 := f_k_val * (1 - expected_score_1) * r_battle.rating;
      increment_2 := f_k_val * (0 - expected_score_2) * r_battle.rating;
    ELSE
      increment_1 := f_k_val * (0 - expected_score_1) * r_battle.rating;
      increment_2 := f_k_val * (1 - expected_score_2) * r_battle.rating;
    END IF;

    f_new_entry_1_score := score_1 + CAST(increment_1 AS int);
    f_new_entry_2_score := score_2 + CAST(increment_2 AS int);
    -- entry1
    UPDATE t_entry_scores
      SET score = f_new_entry_1_score, num_battles = num_battles + 1
      WHERE eid = r_battle.entry_1_id;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records were updated
      INSERT INTO t_entry_scores VALUES (r_battle.entry_1_id, f_new_entry_1_score, 1);
    END IF;
    -- entry2
    UPDATE t_entry_scores
      SET score = f_new_entry_2_score, num_battles = num_battles + 1
      WHERE eid = r_battle.entry_2_id;
    IF NOT FOUND THEN           -- FOUND is a special local variable set to true if one or more records were updated
      INSERT INTO t_entry_scores VALUES (r_battle.entry_2_id, f_new_entry_2_score, 1);
    END IF;
  END LOOP;

  -- Loop to set scores for entries
  FOR r_entry IN SELECT * from t_entry_scores LOOP
    IF run_commit THEN
      UPDATE entries 
        SET score = r_entry.score, num_battles = r_entry.num_battles
        WHERE entries.id = r_entry.eid and (score != r_entry.score OR num_battles != r_entry.num_battles);
    END IF;
    
  END LOOP;

  RETURN 0;
END;
$$
    LANGUAGE plpgsql;


--
-- Name: taste_space2_begin_user_disorder_update(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION taste_space2_begin_user_disorder_update(the_space_id integer, user_layer integer, media_item_layer integer) RETURNS integer
    AS $$
DECLARE
	counter1 int;
	counter2 int;
	index_name name;
BEGIN

	-- To make inserts faster drop the indices and create them at the end of the batch
	index_name := NULL;
	SELECT indexname INTO index_name FROM pg_indexes WHERE indexname = 'index_taste_space2_disorders_on_space_id_and_item_id' LIMIT 1;
	IF index_name IS NOT NULL THEN
		DROP INDEX index_taste_space2_disorders_on_space_id_and_item_id;
	END IF;
	
	index_name := NULL;
	SELECT indexname INTO index_name FROM pg_indexes WHERE indexname = 'index_taste_space2_disorders_on_space_id_and_disorder' LIMIT 1;
	IF index_name IS NOT NULL THEN
		DROP INDEX index_taste_space2_disorders_on_space_id_and_disorder;
	END IF;
	
	-- insert new disorders
	counter1 := 0;
	counter2 := 0;
	-- select count(*) into counter1 from taste_space2_disorders
	-- 	where taste_space2_points.space_id = the_space_id and taste_space2_points.layer = user_layer;
	
  INSERT INTO taste_space2_disorders 
    SELECT nextval('taste_space2_disorders_id_seq'::regclass) AS id, the_space_id AS space_id, item_id, 1000 AS disorder
    FROM (SELECT item_id FROM taste_space2_points
    WHERE space_id = the_space_id AND item_layer = user_layer EXCEPT SELECT item_id FROM taste_space2_disorders WHERE space_id = the_space_id) AS TO_INSERT;
	
	-- select count(*) into counter2 from taste_space2_disorders
	-- 	where taste_space2_points.space_id = the_space_id and taste_space2_points.layer = user_layer;
  RETURN counter2 - counter1;
END;
$$
    LANGUAGE plpgsql;


--
-- Name: taste_space2_calculate_user_disorder(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION taste_space2_calculate_user_disorder(space_id integer, user_layer integer, media_item_layer integer, user_id integer) RETURNS integer[]
    AS $$
DECLARE
	total int;
	start_distance real;
	end_distance real;
	origin RECORD;
	rating_info RECORD;
	disorders int;
	temp_ratings_table name;
BEGIN
	total 					:= 0;
	start_distance 	:= 0.0;
	end_distance 		:= 0.0;

	select tablename into temp_ratings_table from pg_tables where tablename = 'temp_ratings' limit 1; 
	IF temp_ratings_table IS NULL THEN
		CREATE TEMP TABLE temp_ratings (
		  item_id integer,
		  expected_rating integer,
		  actual_rating integer,
		  distance real
		  ) ON COMMIT DROP;
	END IF;
	
	select * into origin from taste_space2_points as p where p.space_id = space_id and p.item_layer = user_layer and p.item_id = user_id limit 1;
	if origin IS NULL THEN
		-- RAISE NOTICE 'The user with id % in space % and layer % does not exist.', user_id, space_id, user_layer;
		RETURN ARRAY[0,0];
	END IF;
	
	-- populate a temporary table with each rating for this user with the actual rating in order of distance.
	--
	INSERT into temp_ratings select media_item_id as item_id, 0 as expected_rating, rating as actual_rating, distance from (
	select media_item_ratings.media_item_id, media_item_ratings.rating, 
		(+(c0-origin.c0)*(c0-origin.c0)+(c1-origin.c1)*(c1-origin.c1)+(c2-origin.c2)*(c2-origin.c2)+(c3-origin.c3)*(c3-origin.c3)+(c4-origin.c4)*(c4-origin.c4)+
		(c5-origin.c5)*(c5-origin.c5)+(c6-origin.c6)*(c6-origin.c6)+(c7-origin.c7)*(c7-origin.c7)+(c8-origin.c8)*(c8-origin.c8)+
		(c9-origin.c9)*(c9-origin.c9)+(c10-origin.c10)*(c10-origin.c10)+(c11-origin.c11)*(c11-origin.c11)+(c12-origin.c12)*(c12-origin.c12)+
		(c13-origin.c13)*(c13-origin.c13)+(c14-origin.c14)*(c14-origin.c14)+(c15-origin.c15)*(c15-origin.c15)) as distance 
		from media_item_ratings join taste_space2_points as p on p.item_id = media_item_ratings.media_item_id 
		where p.space_id = space_id and p.item_layer = media_item_layer and media_item_ratings.user_id = user_id 
		order by distance
	) as r;
		
	-- update the expected rating group for each rating record in the temp table
	--
	FOR rating_info IN select actual_rating as rating, count(item_id) as count from temp_ratings 
		group by actual_rating 
		order by actual_rating desc
	LOOP
		total := total + rating_info.count;
		select distance into end_distance from temp_ratings order by distance limit 1 offset total;
		
		if end_distance IS NULL then
			select max(distance) + 1 into end_distance from temp_ratings;
		end if;

		-- RAISE NOTICE 'Expected rating % count % Distances: % %', rating_info.rating, rating_info.count, start_distance, end_distance;
		
		update temp_ratings set expected_rating = rating_info.rating where temp_ratings.distance >= start_distance and temp_ratings.distance < end_distance;
		start_distance := end_distance;
	END LOOP;

	-- DEBUG
	-- FOR rating_info IN select * from temp_ratings 
	-- LOOP
	-- 	RAISE NOTICE 'Item % expected % actual % distance %', rating_info.item_id, rating_info.expected_rating, rating_info.actual_rating, rating_info.distance;
	-- END LOOP;

	-- now sum up all diffs between expected and actual
	-- we're kind of double counting but disorders are used to find relative disorder so we avoid a divide by 2 here
	--
	select sum(abs(expected_rating - actual_rating)) into disorders from temp_ratings;
	
	delete from temp_ratings;
  RETURN ARRAY[disorders, total];
END;
$$
    LANGUAGE plpgsql;


--
-- Name: taste_space2_end_user_disorder_update(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION taste_space2_end_user_disorder_update(the_space_id integer, user_layer integer, media_item_layer integer) RETURNS integer
    AS $$
BEGIN

	-- now recreate the indices
	CREATE UNIQUE INDEX index_taste_space2_disorders_on_space_id_and_item_id ON taste_space2_disorders(space_id, item_id);
	CREATE INDEX index_taste_space2_disorders_on_space_id_and_disorder ON taste_space2_disorders(space_id, disorder);

	RETURN 0;
END;
$$
    LANGUAGE plpgsql;


--
-- Name: taste_space2_update_user_disorder(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION taste_space2_update_user_disorder(the_space_id integer, user_layer integer, media_item_layer integer, user_id integer) RETURNS real
    AS $$
DECLARE
	user_id_result RECORD;
	disorder_result int ARRAY[2];
	disorder_value real;
BEGIN

	select taste_space2_calculate_user_disorder(the_space_id, user_layer, media_item_layer, user_id) into disorder_result;
		
	IF disorder_result[2] > 0 THEN
		disorder_value := cast(disorder_result[1] as real)/ cast(disorder_result[2] as real);
	ELSE
		disorder_value := 0;
	END IF;
		
	-- Uncomment to output progress
	-- RAISE NOTICE 'update user_id % disorder result: % = % / %', user_id, disorder_value, disorder_result[1], disorder_result[2];

	update taste_space2_disorders set disorder = disorder_value where space_id = the_space_id and item_id = user_id;

  RETURN disorder_value;
END;
$$
    LANGUAGE plpgsql;


--
-- Name: taste_space2_update_user_disorders(integer, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION taste_space2_update_user_disorders(the_space_id integer, user_layer integer, media_item_layer integer, the_offset integer, the_limit integer) RETURNS integer
    AS $$
DECLARE
	user_id_result RECORD;
	counter int;
BEGIN

	counter := 0;
	
	-- loop through the batch of users who have disorder records 
	FOR user_id_result IN (
		select item_id as user_id from taste_space2_disorders where space_id = the_space_id
		order by id 
		offset the_offset
		limit the_limit
		)
	LOOP
		perform taste_space2_update_user_disorder(the_space_id, user_layer, media_item_layer, user_id_result.user_id);
		counter := counter + 1;
	END LOOP;

  RETURN counter;
END;
$$
    LANGUAGE plpgsql;


--
-- Name: array_accum(anyelement); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE array_accum(anyelement) (
    SFUNC = array_append,
    STYPE = anyarray,
    INITCOND = '{}'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account_actions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE account_actions (
    id integer NOT NULL,
    account_user_id integer,
    admin_id integer,
    entry_id integer,
    media_item_id integer,
    action character varying(255),
    comment text,
    created_at timestamp without time zone,
    actionable_id integer,
    actionable_type character varying(255),
    data1 integer,
    data2 integer
);


--
-- Name: account_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE account_actions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: account_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE account_actions_id_seq OWNED BY account_actions.id;


--
-- Name: achievements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE achievements (
    id integer NOT NULL,
    plaque_id integer,
    entry_id integer,
    prize_winner_id integer,
    user_id integer,
    description character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    contest_id integer,
    period date,
    best_of_best_genre_id integer,
    chart_position_id integer
);


--
-- Name: achievements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE achievements_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: achievements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE achievements_id_seq OWNED BY achievements.id;


--
-- Name: activation_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activation_requests (
    id integer NOT NULL,
    user_id integer NOT NULL,
    activation_code character varying(20),
    status integer DEFAULT 0 NOT NULL,
    activation_type integer DEFAULT 0,
    promotion_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone
);


--
-- Name: activation_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activation_requests_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: activation_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activation_requests_id_seq OWNED BY activation_requests.id;


--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE active_admin_comments (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    resource_type character varying(255) NOT NULL,
    author_id integer,
    author_type character varying(255),
    body text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    namespace character varying(255)
);


--
-- Name: admin_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: admin_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_notes_id_seq OWNED BY active_admin_comments.id;


--
-- Name: administration_ignore_object_matches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE administration_ignore_object_matches (
    id integer NOT NULL,
    foreign_object_model character varying(255) NOT NULL,
    foreign_object_id integer NOT NULL,
    our_object_model character varying(255) NOT NULL,
    our_object_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    unsure boolean DEFAULT false NOT NULL
);


--
-- Name: administration_ignore_object_matches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE administration_ignore_object_matches_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: administration_ignore_object_matches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE administration_ignore_object_matches_id_seq OWNED BY administration_ignore_object_matches.id;


--
-- Name: ads_ads; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ads_ads (
    id integer NOT NULL,
    utc_start_time timestamp without time zone NOT NULL,
    utc_end_time timestamp without time zone NOT NULL,
    headline character varying(255),
    body character varying(255),
    advertisable_id integer,
    advertisable_type character varying(255),
    our_location_id integer,
    poster_id integer,
    owner_id integer,
    impressions_allotted integer,
    status integer DEFAULT 2,
    delta boolean DEFAULT true NOT NULL
);


--
-- Name: ads_ads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ads_ads_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ads_ads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ads_ads_id_seq OWNED BY ads_ads.id;


--
-- Name: ads_channel_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ads_channel_groups (
    id integer NOT NULL,
    ad_id integer NOT NULL,
    channel_group_id integer NOT NULL
);


--
-- Name: ads_channel_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ads_channel_groups_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ads_channel_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ads_channel_groups_id_seq OWNED BY ads_channel_groups.id;


--
-- Name: anonymous_ratings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE anonymous_ratings (
    id integer NOT NULL,
    media_item_id integer,
    ip_address character varying(255),
    rating integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: anonymous_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE anonymous_ratings_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: anonymous_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE anonymous_ratings_id_seq OWNED BY anonymous_ratings.id;


--
-- Name: anonymous_user_records; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE anonymous_user_records (
    id integer NOT NULL,
    ip character varying(255) NOT NULL,
    trial_judge_count integer DEFAULT 0,
    created_at timestamp without time zone
);


--
-- Name: anonymous_user_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE anonymous_user_records_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: anonymous_user_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE anonymous_user_records_id_seq OWNED BY anonymous_user_records.id;


--
-- Name: app_stuffs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE app_stuffs (
    id integer NOT NULL,
    app_hash bytea,
    stuff_type character varying(32)
);


--
-- Name: app_stuffs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE app_stuffs_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: app_stuffs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE app_stuffs_id_seq OWNED BY app_stuffs.id;


--
-- Name: artist_accesses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE artist_accesses (
    id integer NOT NULL,
    clip_id integer,
    description text,
    ordinal integer,
    active boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    flags integer DEFAULT 0 NOT NULL,
    media_type_id integer
);


--
-- Name: artist_accesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE artist_accesses_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: artist_accesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE artist_accesses_id_seq OWNED BY artist_accesses.id;


--
-- Name: artist_referrals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE artist_referrals (
    id integer NOT NULL,
    user_id integer NOT NULL,
    referral_name character varying(255),
    email_address character varying(255) NOT NULL,
    count integer DEFAULT 1,
    declined boolean DEFAULT false,
    autogenerated boolean DEFAULT false,
    converted_at timestamp without time zone,
    converted_user_id integer,
    key character varying(12) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: artist_referrals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE artist_referrals_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: artist_referrals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE artist_referrals_id_seq OWNED BY artist_referrals.id;


--
-- Name: authnet_cim_payment_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE authnet_cim_payment_profiles (
    id integer NOT NULL,
    cim_profile_id integer,
    external_id character varying(255),
    pmt_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    profile_name character varying(25),
    flags integer DEFAULT 0 NOT NULL
);


--
-- Name: authnet_cim_payment_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authnet_cim_payment_profiles_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: authnet_cim_payment_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authnet_cim_payment_profiles_id_seq OWNED BY authnet_cim_payment_profiles.id;


--
-- Name: authnet_cim_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE authnet_cim_profiles (
    id integer NOT NULL,
    billable_id integer,
    billable_type character varying(255),
    external_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: authnet_cim_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authnet_cim_profiles_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: authnet_cim_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authnet_cim_profiles_id_seq OWNED BY authnet_cim_profiles.id;


--
-- Name: authnet_cim_shipping_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE authnet_cim_shipping_profiles (
    id integer NOT NULL,
    cim_profile_id integer,
    external_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: authnet_cim_shipping_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authnet_cim_shipping_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: authnet_cim_shipping_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authnet_cim_shipping_profiles_id_seq OWNED BY authnet_cim_shipping_profiles.id;


--
-- Name: authorizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE authorizations (
    id integer NOT NULL,
    user_id integer NOT NULL,
    access integer NOT NULL,
    created_at timestamp without time zone
);


--
-- Name: authorizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authorizations_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: authorizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authorizations_id_seq OWNED BY authorizations.id;


--
-- Name: background_task_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE background_task_logs (
    id integer NOT NULL,
    machine character varying(255),
    state integer DEFAULT 0,
    target_run_time timestamp without time zone,
    start_time timestamp without time zone,
    deadline timestamp without time zone,
    background_task_id integer NOT NULL,
    completed timestamp without time zone
);


--
-- Name: background_task_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE background_task_logs_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: background_task_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE background_task_logs_id_seq OWNED BY background_task_logs.id;


--
-- Name: background_tasks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE background_tasks (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    cmd character varying(255) NOT NULL,
    max_time integer DEFAULT 5,
    period integer DEFAULT 60,
    state integer DEFAULT 0,
    next_run_time timestamp without time zone,
    cmd_klass character varying(255),
    cmd_args character varying(255),
    pool character varying(255) DEFAULT 'normal'::character varying NOT NULL
);


--
-- Name: background_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE background_tasks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: background_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE background_tasks_id_seq OWNED BY background_tasks.id;


--
-- Name: bad_ip_addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bad_ip_addresses (
    id integer NOT NULL,
    address character varying(255) NOT NULL
);


--
-- Name: bad_ip_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bad_ip_addresses_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: bad_ip_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bad_ip_addresses_id_seq OWNED BY bad_ip_addresses.id;


--
-- Name: bands; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bands (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    key character varying(12)
);


--
-- Name: bands_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bands_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: bands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bands_id_seq OWNED BY bands.id;


--
-- Name: banner_hits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE banner_hits (
    id integer NOT NULL,
    entry_id integer,
    banner_style integer,
    referrer character varying(255),
    view_count integer DEFAULT 0,
    click_count integer DEFAULT 0,
    last_viewed_at timestamp without time zone,
    last_clicked_at timestamp without time zone,
    subject_class_name character varying(255),
    subject_id integer
);


--
-- Name: banner_hits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE banner_hits_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: banner_hits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE banner_hits_id_seq OWNED BY banner_hits.id;


--
-- Name: banner_themes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE banner_themes (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    attachment_file_name character varying(255) DEFAULT 'can_1.png'::character varying NOT NULL,
    font_name character varying(255) DEFAULT 'Arial'::character varying NOT NULL,
    font_size integer DEFAULT 12 NOT NULL,
    font_color character varying(255) DEFAULT 'white'::character varying NOT NULL,
    y_offset integer DEFAULT 120 NOT NULL,
    attachment_content_type character varying(255),
    attachment_file_size integer,
    attachment_updated_at timestamp without time zone
);


--
-- Name: banner_themes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE banner_themes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: banner_themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE banner_themes_id_seq OWNED BY banner_themes.id;


--
-- Name: battle_behavior_ratings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE battle_behavior_ratings (
    id integer NOT NULL,
    contest_id integer NOT NULL,
    user_id integer NOT NULL,
    battle_type integer,
    is_composite boolean NOT NULL,
    battle_count integer NOT NULL,
    rating real,
    behavior_class_name character varying(255) NOT NULL,
    behavior_data text,
    parameter_id integer
);


--
-- Name: battle_behavior_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE battle_behavior_ratings_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: battle_behavior_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE battle_behavior_ratings_id_seq OWNED BY battle_behavior_ratings.id;


--
-- Name: battle_influences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE battle_influences (
    id integer NOT NULL,
    user_id integer NOT NULL,
    year integer NOT NULL,
    month integer NOT NULL,
    composite_score double precision NOT NULL,
    battles_this_month integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: battle_influences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE battle_influences_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: battle_influences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE battle_influences_id_seq OWNED BY battle_influences.id;


--
-- Name: battles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE battles (
    id integer NOT NULL,
    user_id integer NOT NULL,
    contest_id integer NOT NULL,
    entry_1_id integer NOT NULL,
    entry_2_id integer NOT NULL,
    new_entry_1_score integer,
    new_entry_2_score integer,
    score integer,
    scored_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    function_profile_id integer,
    battle_type integer DEFAULT 0,
    battle_power real,
    entry_1_rank integer,
    entry_2_rank integer,
    parent_id integer,
    disqualified integer,
    uniquifier integer DEFAULT 0,
    source character varying(32),
    battle_source integer DEFAULT 0
);
ALTER TABLE ONLY battles ALTER COLUMN id SET STATISTICS 100;
ALTER TABLE ONLY battles ALTER COLUMN user_id SET STATISTICS 500;


--
-- Name: battles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE battles_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: battles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE battles_id_seq OWNED BY battles.id;


--
-- Name: beta_invitations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE beta_invitations (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email_address character varying(255),
    created_at timestamp without time zone,
    reason character varying(255),
    referred_by character varying(255),
    granted integer DEFAULT 0
);


--
-- Name: beta_invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE beta_invitations_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: beta_invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE beta_invitations_id_seq OWNED BY beta_invitations.id;


--
-- Name: blacklists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE blacklists (
    id integer NOT NULL,
    delete_me integer
);


--
-- Name: blacklists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE blacklists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: blacklists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE blacklists_id_seq OWNED BY blacklists.id;


--
-- Name: build_statuses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE build_statuses (
    id integer NOT NULL,
    job character varying(255),
    build integer,
    phase character varying(255),
    status character varying(255),
    build_url character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: build_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE build_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: build_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE build_statuses_id_seq OWNED BY build_statuses.id;


--
-- Name: bunchball_trophies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bunchball_trophies (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    full_icon character varying(255),
    thumb_icon character varying(255),
    action_link character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bunchball_trophies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bunchball_trophies_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: bunchball_trophies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bunchball_trophies_id_seq OWNED BY bunchball_trophies.id;


--
-- Name: bunchball_trophy_grants; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bunchball_trophy_grants (
    id integer NOT NULL,
    user_id integer NOT NULL,
    trophy_id integer NOT NULL,
    bb_timestamp integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bunchball_trophy_grants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bunchball_trophy_grants_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: bunchball_trophy_grants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bunchball_trophy_grants_id_seq OWNED BY bunchball_trophy_grants.id;


--
-- Name: calendars_events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE calendars_events (
    calendar_id integer NOT NULL,
    event_id integer NOT NULL,
    created_at timestamp without time zone
);


--
-- Name: canonical_artist_names; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE canonical_artist_names (
    id integer NOT NULL,
    name character varying(255),
    metaphone character varying(255),
    has_trusted_related_artist_tags boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: canonical_artist_names_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE canonical_artist_names_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: canonical_artist_names_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE canonical_artist_names_id_seq OWNED BY canonical_artist_names.id;


--
-- Name: captchas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE captchas (
    id integer NOT NULL,
    challenge character varying(80) NOT NULL,
    file_name character varying(80) NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: captchas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE captchas_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: captchas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE captchas_id_seq OWNED BY captchas.id;


--
-- Name: cart_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cart_items (
    id integer NOT NULL,
    cart_id integer NOT NULL,
    media_item_id integer,
    price numeric(8,2) DEFAULT 0,
    created_at timestamp without time zone,
    added_from integer DEFAULT 0,
    purchasable_id integer,
    purchasable_type character varying(255),
    artist_share_value numeric,
    options text,
    qty integer DEFAULT 1,
    returned_qty integer
);


--
-- Name: cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cart_items_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cart_items_id_seq OWNED BY cart_items.id;


--
-- Name: carts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE carts (
    id integer NOT NULL,
    created_at timestamp without time zone,
    resolved_at timestamp without time zone,
    user_id integer DEFAULT 0,
    status integer DEFAULT 0,
    paypal_gross numeric(8,2) DEFAULT 0,
    paypal_fee numeric(8,2) DEFAULT 0,
    paypal_id character varying(20),
    key character varying(12) NOT NULL,
    paypal_raw text,
    download_count integer DEFAULT 0,
    paypal_count integer DEFAULT 0,
    fav_artist_id integer,
    fulfilled_on date
);


--
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE carts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE carts_id_seq OWNED BY carts.id;


--
-- Name: catalog_item_photos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE catalog_item_photos (
    id integer NOT NULL,
    catalog_item_id integer,
    photo_file_name character varying(255),
    photo_content_type character varying(255),
    photo_file_size integer,
    photo_uploaded_at timestamp without time zone,
    ordinal integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: catalog_item_photos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE catalog_item_photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: catalog_item_photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE catalog_item_photos_id_seq OWNED BY catalog_item_photos.id;


--
-- Name: catalog_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE catalog_items (
    id integer NOT NULL,
    inventory_item_id integer,
    flags integer DEFAULT 0,
    remote_sku character varying(255),
    basic_artist_share numeric,
    premium_artist_share numeric,
    title_en character varying(255),
    title_es character varying(255),
    short_desc_en text,
    short_desc_es text,
    long_desc_en text,
    long_desc_es text,
    ordinal integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: catalog_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE catalog_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: catalog_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE catalog_items_id_seq OWNED BY catalog_items.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    media_type_id integer NOT NULL,
    ordinal integer,
    status integer
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: channel_genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE channel_genres (
    id integer NOT NULL,
    channel_id integer NOT NULL,
    genre_id integer NOT NULL
);


--
-- Name: channel_genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE channel_genres_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: channel_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE channel_genres_id_seq OWNED BY channel_genres.id;


--
-- Name: channel_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE channel_groups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    active boolean DEFAULT true,
    ordinal integer DEFAULT 1,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    promotion_id integer,
    is_not_music boolean DEFAULT false NOT NULL
);


--
-- Name: channel_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE channel_groups_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: channel_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE channel_groups_id_seq OWNED BY channel_groups.id;


--
-- Name: channel_views; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE channel_views (
    id integer NOT NULL,
    user_id integer NOT NULL,
    channel_id integer NOT NULL,
    view_count integer DEFAULT 0
);


--
-- Name: channel_views_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE channel_views_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: channel_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE channel_views_id_seq OWNED BY channel_views.id;


--
-- Name: channels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE channels (
    id integer NOT NULL,
    name character varying(255),
    short_name character varying(255),
    category_id integer,
    ordinal integer,
    status integer DEFAULT 0,
    sms_prefix character varying(10),
    description text,
    media_type_id integer,
    flags integer DEFAULT 0 NOT NULL,
    promotion_id integer,
    upload_region_id integer,
    max_entries_per_user integer DEFAULT 2 NOT NULL,
    one_month date,
    min_rollover_entries integer DEFAULT 100 NOT NULL,
    max_rollover_entries integer DEFAULT 500 NOT NULL,
    percent_rollover_entries integer DEFAULT 50 NOT NULL,
    ad_tag character varying(255),
    upload_media_market_id integer,
    editorial_playlist_id integer,
    credit_cost integer DEFAULT 0,
    channel_group_id integer DEFAULT 8,
    schedule_klass character varying(255),
    rolls_into_channel_id integer,
    locale character varying(255) DEFAULT 'en'::character varying NOT NULL
);


--
-- Name: channels_gigs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE channels_gigs (
    channel_id integer NOT NULL,
    gig_id integer NOT NULL,
    created_at timestamp without time zone
);


--
-- Name: channels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE channels_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE channels_id_seq OWNED BY channels.id;


--
-- Name: chart_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE chart_items (
    id integer NOT NULL,
    chart_id integer NOT NULL,
    ordinal integer NOT NULL,
    entry_id integer,
    person_id integer,
    flags integer DEFAULT 0 NOT NULL
);


--
-- Name: chart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE chart_items_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: chart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE chart_items_id_seq OWNED BY chart_items.id;


--
-- Name: charts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE charts (
    id integer NOT NULL,
    channel_id integer NOT NULL,
    chart_type integer NOT NULL,
    title character varying(255) NOT NULL,
    week_of date NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: charts_best_of_best_approvals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE charts_best_of_best_approvals (
    id integer NOT NULL,
    approver_id integer NOT NULL,
    artist_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: charts_best_of_best_approvals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE charts_best_of_best_approvals_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: charts_best_of_best_approvals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE charts_best_of_best_approvals_id_seq OWNED BY charts_best_of_best_approvals.id;


--
-- Name: charts_best_of_best_genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE charts_best_of_best_genres (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: charts_best_of_best_genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE charts_best_of_best_genres_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: charts_best_of_best_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE charts_best_of_best_genres_id_seq OWNED BY charts_best_of_best_genres.id;


--
-- Name: charts_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE charts_categories (
    id integer NOT NULL,
    klass character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    max_items_to_show integer NOT NULL,
    max_items_to_record integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: charts_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE charts_categories_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: charts_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE charts_categories_id_seq OWNED BY charts_categories.id;


--
-- Name: charts_charts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE charts_charts (
    id integer NOT NULL,
    charts_category_id integer NOT NULL,
    chartable_id integer NOT NULL,
    chartable_type character varying(255) NOT NULL,
    item_klass character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    end_at date NOT NULL,
    start_at date NOT NULL,
    max_items_to_show integer NOT NULL,
    max_items_to_record integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    flags integer DEFAULT 0 NOT NULL
);


--
-- Name: charts_charts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE charts_charts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: charts_charts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE charts_charts_id_seq OWNED BY charts_charts.id;


--
-- Name: charts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE charts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: charts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE charts_id_seq OWNED BY charts.id;


--
-- Name: charts_positions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE charts_positions (
    id integer NOT NULL,
    charts_chart_id integer NOT NULL,
    ordinal integer NOT NULL,
    item_id integer NOT NULL,
    previous_ordinal integer,
    charted_count integer,
    peak_ordinal integer
);


--
-- Name: charts_positions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE charts_positions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: charts_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE charts_positions_id_seq OWNED BY charts_positions.id;


--
-- Name: chats; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE chats (
    id integer NOT NULL,
    created_at timestamp without time zone,
    user_id integer NOT NULL,
    room_id integer NOT NULL,
    key character varying(12) NOT NULL,
    comment character varying(255)
);


--
-- Name: chats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE chats_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: chats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE chats_id_seq OWNED BY chats.id;


--
-- Name: checksums; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE checksums (
    id integer NOT NULL,
    media_item_id integer NOT NULL,
    md5 character varying(32) NOT NULL,
    converted integer NOT NULL
);


--
-- Name: checksums_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE checksums_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: checksums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE checksums_id_seq OWNED BY checksums.id;


--
-- Name: classify_competition_genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE classify_competition_genres (
    id integer NOT NULL,
    genre_id integer NOT NULL,
    competition_id integer NOT NULL,
    creator_id integer
);


--
-- Name: classify_competition_genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE classify_competition_genres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: classify_competition_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE classify_competition_genres_id_seq OWNED BY classify_competition_genres.id;


--
-- Name: classify_genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE classify_genres (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    parent_id integer,
    lft integer,
    rgt integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: classify_genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE classify_genres_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: classify_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE classify_genres_id_seq OWNED BY classify_genres.id;


--
-- Name: classify_media_item_genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE classify_media_item_genres (
    id integer NOT NULL,
    genre_id integer,
    media_item_id integer,
    creator_id integer,
    flags integer DEFAULT 0 NOT NULL
);


--
-- Name: classify_media_item_genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE classify_media_item_genres_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: classify_media_item_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE classify_media_item_genres_id_seq OWNED BY classify_media_item_genres.id;


--
-- Name: co_brandings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE co_brandings (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    flags integer DEFAULT 0 NOT NULL
);


--
-- Name: co_brandings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE co_brandings_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: co_brandings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE co_brandings_id_seq OWNED BY co_brandings.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    title character varying(50) DEFAULT ''::character varying,
    comment text DEFAULT ''::text,
    created_at timestamp without time zone NOT NULL,
    commentable_id integer DEFAULT 0 NOT NULL,
    commentable_type character varying(64) DEFAULT ''::character varying NOT NULL,
    user_id integer DEFAULT 0 NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    deleted_by integer,
    deleted_at timestamp without time zone
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: compete_competitions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE compete_competitions (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    judging_state integer DEFAULT 0 NOT NULL,
    entering_state integer DEFAULT 0 NOT NULL
);


--
-- Name: compete_competitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE compete_competitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: compete_competitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE compete_competitions_id_seq OWNED BY compete_competitions.id;


--
-- Name: compete_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE compete_entries (
    id integer NOT NULL,
    media_item_id integer NOT NULL,
    competition_id integer NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    state integer DEFAULT 0 NOT NULL,
    rank integer NOT NULL
);


--
-- Name: compete_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE compete_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: compete_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE compete_entries_id_seq OWNED BY compete_entries.id;


--
-- Name: complaints; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE complaints (
    id integer NOT NULL,
    complaint_type integer,
    user_id integer NOT NULL,
    reason character varying(255),
    entry_id integer,
    media_item_id integer,
    external_url character varying(255),
    review_status integer DEFAULT 0,
    account_action_id integer,
    created_at timestamp without time zone,
    media_assets_image_id integer,
    sms_entry_id integer,
    listing_key character varying(255)
);


--
-- Name: complaints_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE complaints_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: complaints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE complaints_id_seq OWNED BY complaints.id;


--
-- Name: completes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE completes (
    id integer NOT NULL,
    str character varying(255) NOT NULL,
    display_str character varying(255) NOT NULL,
    category integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: completes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE completes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: completes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE completes_id_seq OWNED BY completes.id;


--
-- Name: contest_credit_transactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contest_credit_transactions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    transaction_info character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    cost numeric(8,2) DEFAULT 0.0 NOT NULL,
    credits_purchased integer DEFAULT 0 NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: contest_credit_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contest_credit_transactions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: contest_credit_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contest_credit_transactions_id_seq OWNED BY contest_credit_transactions.id;


--
-- Name: contest_credits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contest_credits (
    id integer NOT NULL,
    contest_credit_transaction_id integer NOT NULL,
    user_id integer NOT NULL,
    contest_id integer DEFAULT 0,
    redeemed_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: contest_credits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contest_credits_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: contest_credits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contest_credits_id_seq OWNED BY contest_credits.id;


--
-- Name: contest_cruft; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contest_cruft (
    id integer,
    channel_id integer,
    name character varying(255),
    description text,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    review_status integer,
    first_place_entry_id integer,
    second_place_entry_id integer,
    third_place_entry_id integer,
    year integer,
    month integer,
    created_at timestamp without time zone,
    distribution_function_profile_id integer,
    flags integer
);


--
-- Name: contest_templates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contest_templates (
    id integer NOT NULL,
    description character varying(255),
    channel_id integer,
    prize_type integer DEFAULT 1
);


--
-- Name: contest_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contest_templates_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: contest_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contest_templates_id_seq OWNED BY contest_templates.id;


--
-- Name: contests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contests (
    id integer NOT NULL,
    channel_id integer NOT NULL,
    name character varying(255),
    description text,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    review_status integer DEFAULT 0,
    first_place_entry_id integer,
    year integer,
    month integer,
    created_at timestamp without time zone,
    distribution_function_profile_id integer,
    flags integer DEFAULT 0 NOT NULL,
    orig_channel_id integer,
    basement_score integer DEFAULT 1436000 NOT NULL,
    basement_battles integer DEFAULT 20 NOT NULL,
    battles_per_user integer DEFAULT 1000,
    promotion_id integer,
    minimum_battle_power real DEFAULT 0.0 NOT NULL,
    short_name character varying(255),
    headline character varying(255),
    banner_theme_id integer DEFAULT 1 NOT NULL,
    menu_name character varying(255),
    rolls_into_contest_id integer,
    num_to_roll integer DEFAULT 1,
    phase_ordinal integer DEFAULT 0 NOT NULL,
    schedule_id integer,
    entry_start_time timestamp without time zone,
    entry_end_time timestamp without time zone,
    menu_start_time timestamp without time zone,
    menu_end_time timestamp without time zone,
    entry_group_id integer,
    entries_per_user integer DEFAULT 1 NOT NULL,
    upload_region_id integer,
    is_premium boolean DEFAULT false NOT NULL
);


--
-- Name: contests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contests_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: contests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contests_id_seq OWNED BY contests.id;


--
-- Name: custom_registrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE custom_registrations (
    id integer NOT NULL,
    promotion_id integer,
    flags integer DEFAULT 0 NOT NULL,
    user_type integer,
    redirect_url character varying(255),
    reg_tracking_hdr text,
    reg_tracking_ftr text,
    success_tracking_hdr text,
    success_tracking_ftr text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    existing_usr_post_login_redirect_url character varying(255),
    already_upgraded_user_redirect_url character varying(255)
);


--
-- Name: custom_registrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE custom_registrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: custom_registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE custom_registrations_id_seq OWNED BY custom_registrations.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0,
    attempts integer DEFAULT 0,
    handler text,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    queue character varying(255)
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: demo_battles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE demo_battles (
    id integer NOT NULL,
    entry_id integer NOT NULL,
    user_id integer NOT NULL,
    demo_group_id integer NOT NULL,
    battle_id integer
);


--
-- Name: demo_battles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE demo_battles_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: demo_battles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE demo_battles_id_seq OWNED BY demo_battles.id;


--
-- Name: demo_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE demo_categories (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255) NOT NULL
);


--
-- Name: demo_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE demo_categories_id_seq
    START WITH 5
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: demo_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE demo_categories_id_seq OWNED BY demo_categories.id;


--
-- Name: demo_entry_statistics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE demo_entry_statistics (
    id integer NOT NULL,
    entry_id integer NOT NULL,
    demo_profile_id integer NOT NULL,
    demo_group_id integer NOT NULL,
    needed_battle_count integer DEFAULT 0 NOT NULL,
    battle_count integer DEFAULT 0 NOT NULL,
    liked integer DEFAULT 0 NOT NULL,
    disliked integer DEFAULT 0 NOT NULL,
    state integer DEFAULT 0 NOT NULL
);


--
-- Name: demo_entry_statistics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE demo_entry_statistics_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: demo_entry_statistics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE demo_entry_statistics_id_seq OWNED BY demo_entry_statistics.id;


--
-- Name: demo_group_partitions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE demo_group_partitions (
    id integer NOT NULL,
    demo_group_id integer NOT NULL,
    demo_partition_id integer NOT NULL
);


--
-- Name: demo_group_partitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE demo_group_partitions_id_seq
    START WITH 19
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: demo_group_partitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE demo_group_partitions_id_seq OWNED BY demo_group_partitions.id;


--
-- Name: demo_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE demo_groups (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: demo_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE demo_groups_id_seq
    START WITH 11
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: demo_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE demo_groups_id_seq OWNED BY demo_groups.id;


--
-- Name: demo_partitions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE demo_partitions (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    demo_category_id integer NOT NULL,
    definition character varying(255) NOT NULL
);


--
-- Name: demo_partitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE demo_partitions_id_seq
    START WITH 7
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: demo_partitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE demo_partitions_id_seq OWNED BY demo_partitions.id;


--
-- Name: demo_profile_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE demo_profile_groups (
    id integer NOT NULL,
    demo_profile_id integer NOT NULL,
    demo_group_id integer NOT NULL,
    needed_battle_count integer NOT NULL
);


--
-- Name: demo_profile_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE demo_profile_groups_id_seq
    START WITH 9
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: demo_profile_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE demo_profile_groups_id_seq OWNED BY demo_profile_groups.id;


--
-- Name: demo_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE demo_profiles (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    user_id integer DEFAULT 0 NOT NULL,
    status integer DEFAULT 0 NOT NULL
);


--
-- Name: demo_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE demo_profiles_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: demo_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE demo_profiles_id_seq OWNED BY demo_profiles.id;


--
-- Name: demo_user_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE demo_user_groups (
    id integer NOT NULL,
    user_id integer,
    demo_group_id integer
);


--
-- Name: demo_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE demo_user_groups_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: demo_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE demo_user_groups_id_seq OWNED BY demo_user_groups.id;


--
-- Name: discovery_ratings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE discovery_ratings (
    id integer NOT NULL,
    channel_id integer,
    discovery_rating integer,
    discovery_type integer DEFAULT 0,
    disqualified integer DEFAULT 0,
    duration integer,
    grid_location integer,
    "group" integer,
    media_item_id integer NOT NULL,
    user_id integer,
    source character varying(255),
    session_key character varying(12),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    recorded_at timestamp without time zone
);


--
-- Name: discovery_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE discovery_ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: discovery_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE discovery_ratings_id_seq OWNED BY discovery_ratings.id;


--
-- Name: dismissed_dialogs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dismissed_dialogs (
    id integer NOT NULL,
    user_id integer NOT NULL,
    which integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: dismissed_dialogs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dismissed_dialogs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: dismissed_dialogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dismissed_dialogs_id_seq OWNED BY dismissed_dialogs.id;


--
-- Name: eb_playlist_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE eb_playlist_items (
    id integer NOT NULL,
    eb_playlist_id integer,
    editable_block_id integer,
    ordinal integer
);


--
-- Name: eb_playlist_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE eb_playlist_items_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: eb_playlist_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE eb_playlist_items_id_seq OWNED BY eb_playlist_items.id;


--
-- Name: eb_playlists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE eb_playlists (
    id integer NOT NULL,
    active boolean DEFAULT false NOT NULL,
    pending boolean DEFAULT false NOT NULL,
    user_id integer,
    created_at timestamp without time zone,
    activated_at timestamp without time zone,
    deactivated_at timestamp without time zone,
    block_tag character varying(255) NOT NULL
);


--
-- Name: eb_playlists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE eb_playlists_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: eb_playlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE eb_playlists_id_seq OWNED BY eb_playlists.id;


--
-- Name: ecommerce_inventory_item_optgroups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ecommerce_inventory_item_optgroups (
    id integer NOT NULL,
    inventory_item_id integer,
    flags integer DEFAULT 0,
    name character varying(255),
    description text,
    field_type character varying(255),
    ordinal integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ecommerce_inventory_item_optgroups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ecommerce_inventory_item_optgroups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ecommerce_inventory_item_optgroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ecommerce_inventory_item_optgroups_id_seq OWNED BY ecommerce_inventory_item_optgroups.id;


--
-- Name: ecommerce_inventory_item_options; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ecommerce_inventory_item_options (
    id integer NOT NULL,
    option_group_id integer,
    flags integer DEFAULT 0,
    sku_stub character varying(255),
    name character varying(255),
    price_modifier numeric,
    ordinal integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ecommerce_inventory_item_options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ecommerce_inventory_item_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ecommerce_inventory_item_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ecommerce_inventory_item_options_id_seq OWNED BY ecommerce_inventory_item_options.id;


--
-- Name: ecommerce_inventory_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ecommerce_inventory_items (
    id integer NOT NULL,
    sku character varying(255),
    flags integer DEFAULT 0,
    name character varying(255),
    description text,
    price numeric,
    rebill_interval character varying(255),
    interval_multiplyer integer,
    ship_weight numeric,
    ship_price numeric,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    item_type integer
);


--
-- Name: ecommerce_inventory_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ecommerce_inventory_items_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ecommerce_inventory_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ecommerce_inventory_items_id_seq OWNED BY ecommerce_inventory_items.id;


--
-- Name: ecommerce_invoice_bill_addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ecommerce_invoice_bill_addresses (
    id integer NOT NULL,
    invoice_id integer NOT NULL,
    address1 character varying(255),
    address2 character varying(255),
    city character varying(255),
    state character varying(255),
    country character varying(255),
    zip character varying(255),
    phone character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ecommerce_invoice_bill_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ecommerce_invoice_bill_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ecommerce_invoice_bill_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ecommerce_invoice_bill_addresses_id_seq OWNED BY ecommerce_invoice_bill_addresses.id;


--
-- Name: ecommerce_invoice_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ecommerce_invoice_items (
    id integer NOT NULL,
    invoice_id integer,
    inventory_item_id integer,
    flags integer DEFAULT 0,
    sku character varying(255),
    item_name character varying(255),
    qty integer,
    price numeric,
    total numeric,
    rebill_interval character varying(255),
    interval_multiplyer integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    shipping numeric DEFAULT 0
);


--
-- Name: ecommerce_invoice_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ecommerce_invoice_items_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ecommerce_invoice_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ecommerce_invoice_items_id_seq OWNED BY ecommerce_invoice_items.id;


--
-- Name: ecommerce_invoice_notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ecommerce_invoice_notes (
    id integer NOT NULL,
    invoice_id integer,
    user_id integer,
    note text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ecommerce_invoice_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ecommerce_invoice_notes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ecommerce_invoice_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ecommerce_invoice_notes_id_seq OWNED BY ecommerce_invoice_notes.id;


--
-- Name: ecommerce_invoice_ship_addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ecommerce_invoice_ship_addresses (
    id integer NOT NULL,
    invoice_id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    address1 character varying(255),
    address2 character varying(255),
    city character varying(255),
    state character varying(255),
    country character varying(255),
    zip character varying(255),
    phone character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ecommerce_invoice_ship_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ecommerce_invoice_ship_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ecommerce_invoice_ship_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ecommerce_invoice_ship_addresses_id_seq OWNED BY ecommerce_invoice_ship_addresses.id;


--
-- Name: ecommerce_invoice_transactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ecommerce_invoice_transactions (
    id integer NOT NULL,
    invoice_id integer,
    reference_txn_id integer,
    pmt_profile_id integer,
    flags integer DEFAULT 0,
    gateway character varying(255),
    gateway_txn_id character varying(255),
    txn_type character varying(255),
    txn_amount numeric,
    messages text,
    raw_response text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    card_description character varying(255)
);


--
-- Name: ecommerce_invoice_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ecommerce_invoice_transactions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ecommerce_invoice_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ecommerce_invoice_transactions_id_seq OWNED BY ecommerce_invoice_transactions.id;


--
-- Name: ecommerce_invoices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ecommerce_invoices (
    id integer NOT NULL,
    invoiceable_id integer,
    invoiceable_type character varying(255),
    linked_invoice_id integer,
    flags integer DEFAULT 0,
    subtotal numeric,
    tax numeric,
    shipping numeric,
    grand_total numeric,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    age_verification_checked boolean DEFAULT false NOT NULL,
    cart_id integer
);


--
-- Name: ecommerce_invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ecommerce_invoices_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ecommerce_invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ecommerce_invoices_id_seq OWNED BY ecommerce_invoices.id;


--
-- Name: ecommerce_subscription_billing_modifiers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ecommerce_subscription_billing_modifiers (
    id integer NOT NULL,
    subscription_id integer,
    flags integer DEFAULT 0,
    summary character varying(255),
    memo text,
    value numeric,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ecommerce_subscription_billing_modifiers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ecommerce_subscription_billing_modifiers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ecommerce_subscription_billing_modifiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ecommerce_subscription_billing_modifiers_id_seq OWNED BY ecommerce_subscription_billing_modifiers.id;


--
-- Name: ecommerce_subscription_payment_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ecommerce_subscription_payment_profiles (
    id integer NOT NULL,
    subscription_id integer,
    payment_profile_id integer,
    ordinal integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ecommerce_subscription_payment_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ecommerce_subscription_payment_profiles_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ecommerce_subscription_payment_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ecommerce_subscription_payment_profiles_id_seq OWNED BY ecommerce_subscription_payment_profiles.id;


--
-- Name: ecommerce_subscriptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ecommerce_subscriptions (
    id integer NOT NULL,
    subscribable_id integer,
    subscribable_type character varying(255),
    flags integer DEFAULT 0,
    original_invoice_id integer,
    inventory_item_id integer,
    notify_on timestamp without time zone,
    payment_on timestamp without time zone,
    base_price numeric,
    pmt_fail_count integer,
    canceled_on timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    rebill_interval character varying(255),
    interval_multiplyer integer
);


--
-- Name: ecommerce_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ecommerce_subscriptions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ecommerce_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ecommerce_subscriptions_id_seq OWNED BY ecommerce_subscriptions.id;


--
-- Name: editable_block_asset_views; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE editable_block_asset_views (
    id integer NOT NULL,
    editable_block_asset_id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    view_type integer NOT NULL,
    seconds_viewed integer NOT NULL
);


--
-- Name: editable_block_asset_views_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE editable_block_asset_views_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: editable_block_asset_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE editable_block_asset_views_id_seq OWNED BY editable_block_asset_views.id;


--
-- Name: editable_block_assets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE editable_block_assets (
    id integer NOT NULL,
    editable_block_id integer,
    entry_id integer,
    asset_type integer NOT NULL,
    "order" integer,
    key character varying(12) NOT NULL,
    tag character varying(255) NOT NULL,
    family character varying(255),
    text text,
    url text,
    media_file character varying(255),
    file_data bytea,
    image_format character varying(255),
    created_at timestamp without time zone
);


--
-- Name: editable_block_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE editable_block_assets_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: editable_block_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE editable_block_assets_id_seq OWNED BY editable_block_assets.id;


--
-- Name: editable_blocks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE editable_blocks (
    id integer NOT NULL,
    user_id integer,
    published boolean DEFAULT false NOT NULL,
    state integer DEFAULT 0 NOT NULL,
    rvn integer DEFAULT 0 NOT NULL,
    tag character varying(255),
    title character varying(255),
    comment character varying(255),
    created_at timestamp without time zone
);


--
-- Name: editable_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE editable_blocks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: editable_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE editable_blocks_id_seq OWNED BY editable_blocks.id;


--
-- Name: editorial_blocks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE editorial_blocks (
    id integer NOT NULL,
    key character varying(255),
    active_content text,
    draft_content text,
    scheduled_content text,
    activation_task_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: editorial_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE editorial_blocks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: editorial_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE editorial_blocks_id_seq OWNED BY editorial_blocks.id;


--
-- Name: editorial_item_channels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE editorial_item_channels (
    id integer NOT NULL,
    feature_item_id integer,
    channel_id integer
);


--
-- Name: editorial_item_channels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE editorial_item_channels_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: editorial_item_channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE editorial_item_channels_id_seq OWNED BY editorial_item_channels.id;


--
-- Name: ej_page_blocks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ej_page_blocks (
    id integer NOT NULL,
    tag character varying(64),
    ej_rundown_id integer
);


--
-- Name: ej_page_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ej_page_blocks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ej_page_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ej_page_blocks_id_seq OWNED BY ej_page_blocks.id;


--
-- Name: ej_rundown_thangs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ej_rundown_thangs (
    id integer NOT NULL,
    ej_rundown_id integer,
    ej_thang_id integer,
    ordinal integer DEFAULT 0
);


--
-- Name: ej_rundown_thangs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ej_rundown_thangs_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ej_rundown_thangs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ej_rundown_thangs_id_seq OWNED BY ej_rundown_thangs.id;


--
-- Name: ej_rundowns; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ej_rundowns (
    id integer NOT NULL,
    name character varying(64),
    created_at timestamp without time zone
);


--
-- Name: ej_rundowns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ej_rundowns_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ej_rundowns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ej_rundowns_id_seq OWNED BY ej_rundowns.id;


--
-- Name: ej_thangs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ej_thangs (
    id integer NOT NULL,
    media_item_id integer,
    ej_title_image_id integer,
    link_text_1 character varying(48),
    clip_link_1 character varying(128),
    link_text_2 character varying(48),
    clip_link_2 character varying(128),
    link_text_3 character varying(48),
    clip_link_3 character varying(128),
    link_text_4 character varying(48),
    clip_link_4 character varying(128),
    link_text_5 character varying(48),
    clip_link_5 character varying(128)
);


--
-- Name: ej_thangs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ej_thangs_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ej_thangs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ej_thangs_id_seq OWNED BY ej_thangs.id;


--
-- Name: ej_title_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ej_title_images (
    id integer NOT NULL,
    key character varying(12),
    name character varying(64),
    large_title character varying(255),
    med_click character varying(255),
    med_intro character varying(255)
);


--
-- Name: ej_title_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ej_title_images_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ej_title_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ej_title_images_id_seq OWNED BY ej_title_images.id;


--
-- Name: email_campaign_results; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE email_campaign_results (
    id integer NOT NULL,
    email_campaign integer,
    user_id integer,
    key character varying(255),
    result character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: email_campaign_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE email_campaign_results_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: email_campaign_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE email_campaign_results_id_seq OWNED BY email_campaign_results.id;


--
-- Name: embedded_player_hits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE embedded_player_hits (
    id integer NOT NULL,
    referrer character varying(255),
    embedded_player_id integer NOT NULL,
    view_count integer DEFAULT 0,
    click_count integer DEFAULT 0
);


--
-- Name: embedded_player_hits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE embedded_player_hits_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: embedded_player_hits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE embedded_player_hits_id_seq OWNED BY embedded_player_hits.id;


--
-- Name: embedded_players; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE embedded_players (
    id integer NOT NULL,
    key character varying(12) NOT NULL,
    name character varying(80),
    created_at timestamp without time zone,
    deleted boolean DEFAULT false,
    user_id integer,
    entry_id integer,
    media_type_id integer,
    playlist_1_type integer DEFAULT 0,
    playlist_1_id integer DEFAULT 0,
    playlist_2_type integer DEFAULT 0,
    playlist_2_id integer DEFAULT 0,
    playlist_3_type integer DEFAULT 0,
    playlist_3_id integer DEFAULT 0,
    playlist_4_type integer DEFAULT 0,
    playlist_4_id integer DEFAULT 0,
    playlist_5_type integer DEFAULT 0,
    playlist_5_id integer DEFAULT 0,
    autoplay boolean DEFAULT false
);


--
-- Name: embedded_players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE embedded_players_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: embedded_players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE embedded_players_id_seq OWNED BY embedded_players.id;


--
-- Name: entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE entries (
    id integer NOT NULL,
    media_item_id integer NOT NULL,
    contest_id integer NOT NULL,
    promotion_id integer,
    created_at timestamp without time zone NOT NULL,
    review_status integer DEFAULT 0,
    rank integer,
    disqualified integer DEFAULT 0,
    score integer DEFAULT 1500000,
    key character varying(12) NOT NULL,
    num_battles integer DEFAULT 0,
    phase integer DEFAULT 0,
    withdrawn integer DEFAULT 0,
    channel_id integer,
    score_adjustment integer DEFAULT 0
);


--
-- Name: entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE entries_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE entries_id_seq OWNED BY entries.id;


--
-- Name: entry_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE entry_groups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    max_entries integer DEFAULT 1 NOT NULL,
    max_per_contest integer DEFAULT 1 NOT NULL,
    max_per_song integer DEFAULT 1 NOT NULL
);


--
-- Name: entry_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE entry_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: entry_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE entry_groups_id_seq OWNED BY entry_groups.id;


--
-- Name: entry_rank_trackers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE entry_rank_trackers (
    id integer NOT NULL,
    entry_id integer NOT NULL,
    contest_id integer NOT NULL,
    rank integer NOT NULL,
    rank_type integer NOT NULL,
    snapshot_at timestamp without time zone NOT NULL
);


--
-- Name: entry_rank_trackers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE entry_rank_trackers_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: entry_rank_trackers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE entry_rank_trackers_id_seq OWNED BY entry_rank_trackers.id;


--
-- Name: entry_selects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE entry_selects (
    id integer NOT NULL,
    entry_id integer NOT NULL,
    contest_id integer NOT NULL,
    ordinal integer NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    status integer NOT NULL
);


--
-- Name: entry_selects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE entry_selects_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: entry_selects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE entry_selects_id_seq OWNED BY entry_selects.id;


--
-- Name: entry_views; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE entry_views (
    id integer NOT NULL,
    user_id integer,
    entry_id integer NOT NULL,
    media_item_id integer,
    seconds_viewed integer,
    created_at timestamp without time zone NOT NULL,
    playlist_type integer DEFAULT (-1) NOT NULL
);


--
-- Name: entry_views_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE entry_views_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: entry_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE entry_views_id_seq OWNED BY entry_views.id;


--
-- Name: envelopes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE envelopes (
    id integer NOT NULL,
    letter_id integer NOT NULL,
    user_id integer NOT NULL,
    status integer DEFAULT 4 NOT NULL,
    delivered boolean DEFAULT false NOT NULL,
    sent_at timestamp without time zone,
    viewed_at timestamp without time zone,
    deactivated_at timestamp without time zone,
    created_at timestamp without time zone
);


--
-- Name: envelopes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE envelopes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: envelopes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE envelopes_id_seq OWNED BY envelopes.id;


--
-- Name: epk_answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE epk_answers (
    id integer NOT NULL,
    epk_id integer NOT NULL,
    answer_id integer,
    answer text,
    question_id integer NOT NULL,
    number_answer integer,
    date_answer date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: epk_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE epk_answers_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: epk_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE epk_answers_id_seq OWNED BY epk_answers.id;


--
-- Name: epk_available_answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE epk_available_answers (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    question_id integer NOT NULL,
    ordinal integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: epk_available_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE epk_available_answers_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: epk_available_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE epk_available_answers_id_seq OWNED BY epk_available_answers.id;


--
-- Name: epk_questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE epk_questions (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    question_type integer DEFAULT 2 NOT NULL,
    parent_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: epk_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE epk_questions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: epk_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE epk_questions_id_seq OWNED BY epk_questions.id;


--
-- Name: event_source_genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE event_source_genres (
    id integer NOT NULL,
    classify_genre_id integer,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: event_source_genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_source_genres_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: event_source_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_source_genres_id_seq OWNED BY event_source_genres.id;


--
-- Name: events_events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events_events (
    id integer NOT NULL,
    creator_id integer,
    venue_id integer NOT NULL,
    poster_id integer,
    is_all_day boolean DEFAULT false NOT NULL,
    local_start_time timestamp without time zone NOT NULL,
    utc_start_time timestamp without time zone,
    name character varying(80) NOT NULL,
    description text,
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    external_id character varying(255),
    stop_date character varying(255),
    ticket_uri character varying(255),
    delta boolean DEFAULT false NOT NULL
);


--
-- Name: events_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_events_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: events_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_events_id_seq OWNED BY events_events.id;


--
-- Name: events_externals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events_externals (
    id integer NOT NULL,
    user_id integer NOT NULL,
    event_id integer NOT NULL,
    external_id character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: events_externals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_externals_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: events_externals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_externals_id_seq OWNED BY events_externals.id;


--
-- Name: events_genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events_genres (
    id integer NOT NULL,
    events_event_id integer,
    classify_genre_id integer,
    event_source_genre_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: events_genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_genres_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: events_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_genres_id_seq OWNED BY events_genres.id;


--
-- Name: events_performers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events_performers (
    id integer NOT NULL,
    user_id integer,
    external_id character varying(255),
    name character varying(255),
    description text,
    url character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: events_performers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_performers_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: events_performers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_performers_id_seq OWNED BY events_performers.id;


--
-- Name: events_presenters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events_presenters (
    id integer NOT NULL,
    events_event_id integer,
    events_performer_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: events_presenters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_presenters_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: events_presenters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_presenters_id_seq OWNED BY events_presenters.id;


--
-- Name: events_rsvps; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events_rsvps (
    id integer NOT NULL,
    event_id integer NOT NULL,
    user_id integer,
    unlogged_user_id integer,
    attendee_count integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: events_rsvps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_rsvps_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: events_rsvps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_rsvps_id_seq OWNED BY events_rsvps.id;


--
-- Name: events_venues; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events_venues (
    id integer NOT NULL,
    latitude numeric,
    longitude numeric,
    duplicate_of_id integer,
    our_location_id integer,
    delta boolean DEFAULT false NOT NULL,
    search_weight integer DEFAULT 1 NOT NULL,
    name character varying(80) NOT NULL,
    street_address_1 character varying(80),
    street_address_2 character varying(80),
    city character varying(80),
    region character varying(80),
    postal_code character varying(20),
    country character varying(10),
    time_zone character varying(30),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    external_id character varying(255),
    phone character varying(255),
    fax character varying(255),
    email character varying(255),
    url character varying(255),
    seating integer,
    venue_type character varying(255),
    image_url character varying(255),
    user_id integer
);


--
-- Name: events_venues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_venues_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: events_venues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_venues_id_seq OWNED BY events_venues.id;


--
-- Name: experiments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE experiments (
    id integer NOT NULL,
    klass character varying(255) NOT NULL,
    account character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    controller character varying(255) NOT NULL,
    action character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    goal character varying(255),
    variations character varying(255) NOT NULL,
    active boolean DEFAULT false NOT NULL,
    uri_sensitive boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    tracking_user_type character varying(255)
);


--
-- Name: experiments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE experiments_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: experiments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE experiments_id_seq OWNED BY experiments.id;


--
-- Name: facebook_accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE facebook_accounts (
    id integer NOT NULL,
    user_id integer NOT NULL,
    channel_id integer,
    facebook_id character varying(18) NOT NULL,
    show_battles boolean DEFAULT true,
    show_player boolean DEFAULT true,
    show_video_player boolean DEFAULT false,
    removed boolean DEFAULT false
);


--
-- Name: facebook_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE facebook_accounts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: facebook_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE facebook_accounts_id_seq OWNED BY facebook_accounts.id;


--
-- Name: facebook_api_keys; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE facebook_api_keys (
    id integer NOT NULL,
    api_key character varying(255) NOT NULL,
    secret_key character varying(255) NOT NULL,
    canvas_page_name character varying(255) DEFAULT 'none'::character varying NOT NULL,
    callback_url character varying(255) DEFAULT ''::character varying NOT NULL,
    pretty_errors boolean DEFAULT true,
    app_id character varying(255),
    app_name character varying(255)
);


--
-- Name: facebook_api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE facebook_api_keys_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: facebook_api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE facebook_api_keys_id_seq OWNED BY facebook_api_keys.id;


--
-- Name: facebook_templates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE facebook_templates (
    id integer NOT NULL,
    template_name character varying(255) NOT NULL,
    content_hash character varying(255) NOT NULL,
    bundle_id character varying(255)
);


--
-- Name: facebook_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE facebook_templates_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: facebook_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE facebook_templates_id_seq OWNED BY facebook_templates.id;


--
-- Name: fans; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE fans (
    id integer NOT NULL,
    fan_club_id integer NOT NULL,
    user_id integer NOT NULL,
    active boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    deactivated_at timestamp without time zone,
    is_recommended boolean,
    srt_recommended integer
);


--
-- Name: faq_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE faq_categories (
    id integer NOT NULL,
    ordinal integer,
    active boolean DEFAULT false,
    name character varying(255),
    locale character varying(255) DEFAULT 'en'::character varying,
    feature_category_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: faq_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE faq_categories_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: faq_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE faq_categories_id_seq OWNED BY faq_categories.id;


--
-- Name: faqs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE faqs (
    id integer NOT NULL,
    faq_category_id integer,
    ordinal integer,
    active boolean,
    name character varying(255),
    answer text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: faqs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE faqs_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: faqs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE faqs_id_seq OWNED BY faqs.id;


--
-- Name: favorite_channels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE favorite_channels (
    id integer NOT NULL,
    user_id integer NOT NULL,
    channel_id integer NOT NULL,
    view_count integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: favorite_channels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE favorite_channels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: favorite_channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE favorite_channels_id_seq OWNED BY favorite_channels.id;


--
-- Name: favorite_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE favorite_entries (
    id integer NOT NULL,
    user_id integer NOT NULL,
    entry_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    ordinal integer,
    media_type_id integer
);


--
-- Name: favorite_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE favorite_entries_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: favorite_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE favorite_entries_id_seq OWNED BY favorite_entries.id;


--
-- Name: feature_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE feature_categories (
    id integer NOT NULL,
    item_type integer NOT NULL,
    ordinal integer,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: feature_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feature_categories_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: feature_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE feature_categories_id_seq OWNED BY feature_categories.id;


--
-- Name: feature_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE feature_images (
    id integer NOT NULL,
    item_type integer NOT NULL,
    key character varying(12),
    name character varying(255),
    link character varying(255),
    file_name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: feature_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feature_images_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: feature_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE feature_images_id_seq OWNED BY feature_images.id;


--
-- Name: feature_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE feature_items (
    id integer NOT NULL,
    item_type integer NOT NULL,
    media_type_id integer,
    category_id integer NOT NULL,
    ordinal integer,
    active boolean DEFAULT false,
    featured boolean DEFAULT false,
    date date,
    image_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    headline character varying(255),
    text_1 text,
    text_2 text,
    text_3 text,
    qty_1 integer,
    item_subtype integer,
    status integer DEFAULT 0 NOT NULL,
    link_uri character varying(255),
    image_uri character varying(255),
    flags integer DEFAULT 0 NOT NULL,
    activation_time timestamp without time zone,
    deactivation_time timestamp without time zone,
    editorial_item_image_id integer,
    big_image_id integer,
    deadline character varying(255),
    call_to_action character varying(255),
    call_to_action_uri character varying(255),
    locale character varying(255) DEFAULT 'en'::character varying NOT NULL
);


--
-- Name: feature_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feature_items_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: feature_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE feature_items_id_seq OWNED BY feature_items.id;


--
-- Name: feed_blurbs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE feed_blurbs (
    id integer NOT NULL,
    action integer NOT NULL,
    blurbable_type character varying(255),
    blurbable_id integer,
    user_id integer,
    feed_mill_id integer,
    created_at timestamp without time zone NOT NULL,
    custom_datum integer
);


--
-- Name: feed_blurbs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feed_blurbs_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: feed_blurbs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE feed_blurbs_id_seq OWNED BY feed_blurbs.id;


--
-- Name: feed_mills; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE feed_mills (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    classify_genre_id integer NOT NULL,
    active boolean NOT NULL
);


--
-- Name: feed_mills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feed_mills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: feed_mills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE feed_mills_id_seq OWNED BY feed_mills.id;


--
-- Name: feed_refers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE feed_refers (
    id integer NOT NULL,
    feed_blurb_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: feed_refers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feed_refers_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: feed_refers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE feed_refers_id_seq OWNED BY feed_refers.id;


--
-- Name: form_letters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE form_letters (
    id integer NOT NULL,
    editor_id integer NOT NULL,
    sender_id integer,
    reviewer_id integer,
    form_type integer DEFAULT 0,
    status integer DEFAULT 0,
    flags integer DEFAULT 0,
    name character varying(255) NOT NULL,
    subject character varying(255) NOT NULL,
    purpose character varying(255) DEFAULT NULL::character varying,
    suggestions text,
    plain_text text,
    html_text text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: form_letters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE form_letters_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: form_letters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE form_letters_id_seq OWNED BY form_letters.id;


--
-- Name: free_tracks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE free_tracks (
    id integer NOT NULL,
    media_item_id integer NOT NULL,
    filename character varying(255) NOT NULL,
    original_filename character varying(255) NOT NULL,
    download_count integer DEFAULT 0,
    ordinal integer,
    created_at timestamp without time zone
);


--
-- Name: free_tracks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE free_tracks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: free_tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE free_tracks_id_seq OWNED BY free_tracks.id;


--
-- Name: function_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE function_profiles (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    kind character varying(255) NOT NULL,
    function character varying(255) NOT NULL,
    arg_hash character varying(2048) NOT NULL,
    version integer NOT NULL,
    creator_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: function_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE function_profiles_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: function_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE function_profiles_id_seq OWNED BY function_profiles.id;


--
-- Name: games_talent_battles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE games_talent_battles (
    id integer NOT NULL,
    talent_player_id integer NOT NULL,
    talent_round_id integer NOT NULL,
    points integer,
    created_at timestamp without time zone
);


--
-- Name: games_talent_games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE games_talent_games (
    id integer NOT NULL,
    created_at timestamp without time zone,
    start_time timestamp without time zone,
    end_time timestamp without time zone
);


--
-- Name: games_talent_players; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE games_talent_players (
    id integer NOT NULL,
    user_id integer,
    points integer NOT NULL,
    unregistered_name character varying(40) DEFAULT NULL::character varying,
    key character varying(12) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: games_talent_players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE games_talent_players_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: games_talent_players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE games_talent_players_id_seq OWNED BY games_talent_players.id;


--
-- Name: games_talent_ranks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE games_talent_ranks (
    id integer NOT NULL,
    points integer,
    name character varying(255),
    badge_file character varying(255)
);


--
-- Name: games_talent_rounds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE games_talent_rounds (
    id integer NOT NULL,
    talent_game_id integer NOT NULL,
    contest_id integer NOT NULL,
    entry_1_id integer NOT NULL,
    entry_2_id integer NOT NULL,
    winner_id integer NOT NULL,
    percent integer,
    created_at timestamp without time zone,
    start_time timestamp without time zone,
    end_time timestamp without time zone
);


--
-- Name: games_talent_scripts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE games_talent_scripts (
    id integer NOT NULL,
    text text,
    script_type integer NOT NULL,
    character_type integer NOT NULL,
    comment_block integer
);


--
-- Name: genre_prefs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE genre_prefs (
    id integer NOT NULL,
    user_id integer,
    genre_id integer NOT NULL,
    weight double precision NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    session_key character varying(12)
);


--
-- Name: genre_prefs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE genre_prefs_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: genre_prefs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE genre_prefs_id_seq OWNED BY genre_prefs.id;


--
-- Name: media_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_types (
    id integer NOT NULL,
    name character varying(255),
    item_term character varying(255),
    view_verb character varying(255),
    active boolean,
    tag character varying(255),
    ordinal integer,
    finals_channel_id integer
);


--
-- Name: genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE genres_id_seq
    START WITH 4
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE genres_id_seq OWNED BY media_types.id;


--
-- Name: geo_searches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE geo_searches (
    id integer NOT NULL,
    user_id integer,
    canonical_loc_name character varying(255) NOT NULL,
    city character varying(255),
    state character varying(255),
    zip character varying(255),
    country_code character varying(255),
    lat numeric NOT NULL,
    lng numeric NOT NULL,
    deactivated boolean DEFAULT false NOT NULL,
    ip character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    delta boolean DEFAULT true NOT NULL
);


--
-- Name: geo_searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE geo_searches_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: geo_searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE geo_searches_id_seq OWNED BY geo_searches.id;


--
-- Name: giveaway_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE giveaway_entries (
    id integer NOT NULL,
    giveaway_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: giveaway_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE giveaway_entries_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: giveaway_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE giveaway_entries_id_seq OWNED BY giveaway_entries.id;


--
-- Name: giveaways; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE giveaways (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    key character varying(12) NOT NULL,
    short_description character varying(255) DEFAULT NULL::character varying,
    description text,
    image_1_id integer,
    image_2_id integer,
    email_copy text,
    thanks_copy text,
    terms text,
    start timestamp without time zone,
    "end" timestamp without time zone,
    genre_id integer,
    channel_id integer,
    flags integer DEFAULT 0 NOT NULL,
    creator_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    cobrand_url character varying(255),
    image_cobrand_id integer,
    battles integer DEFAULT 0 NOT NULL
);


--
-- Name: giveaways_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE giveaways_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: giveaways_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE giveaways_id_seq OWNED BY giveaways.id;


--
-- Name: google_tokens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE google_tokens (
    id integer NOT NULL,
    user_id integer NOT NULL,
    key character varying(255) NOT NULL,
    token_type integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: google_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE google_tokens_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: google_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE google_tokens_id_seq OWNED BY google_tokens.id;


--
-- Name: ignored_user_agents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ignored_user_agents (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: ignored_user_agents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ignored_user_agents_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ignored_user_agents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ignored_user_agents_id_seq OWNED BY ignored_user_agents.id;


--
-- Name: illegal_email_domains; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE illegal_email_domains (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    flags integer DEFAULT 0 NOT NULL
);


--
-- Name: illegal_email_domains_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE illegal_email_domains_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: illegal_email_domains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE illegal_email_domains_id_seq OWNED BY illegal_email_domains.id;


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invitations (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    user_id integer NOT NULL,
    invitee character varying(255) NOT NULL,
    invited_id integer
);


--
-- Name: invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invitations_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invitations_id_seq OWNED BY invitations.id;


--
-- Name: item_lists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE item_lists (
    id integer NOT NULL,
    list_type integer NOT NULL,
    scope integer NOT NULL,
    item integer NOT NULL,
    ordinal integer DEFAULT 0,
    permissions integer DEFAULT 0
);


--
-- Name: item_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE item_lists_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: item_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE item_lists_id_seq OWNED BY item_lists.id;


--
-- Name: jango_infos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jango_infos (
    id integer NOT NULL,
    user_id integer NOT NULL,
    signed_up_at timestamp without time zone,
    notified_by_jango_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    flags integer DEFAULT 0 NOT NULL
);


--
-- Name: jango_infos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jango_infos_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jango_infos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jango_infos_id_seq OWNED BY jango_infos.id;


--
-- Name: jury_games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jury_games (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    flags integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: jury_games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jury_games_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jury_games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jury_games_id_seq OWNED BY jury_games.id;


--
-- Name: jury_genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jury_genres (
    id integer NOT NULL,
    jury_game_id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: jury_genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jury_genres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jury_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jury_genres_id_seq OWNED BY jury_genres.id;


--
-- Name: jury_ratings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jury_ratings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    media_item_id integer NOT NULL,
    rating integer NOT NULL,
    other_rating integer NOT NULL,
    source integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: jury_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jury_ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jury_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jury_ratings_id_seq OWNED BY jury_ratings.id;


--
-- Name: jury_regions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jury_regions (
    id integer NOT NULL,
    jury_game_id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: jury_regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jury_regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jury_regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jury_regions_id_seq OWNED BY jury_regions.id;


--
-- Name: jury_trivia_answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jury_trivia_answers (
    id integer NOT NULL,
    user_id integer NOT NULL,
    jury_trivia_question_id integer NOT NULL,
    answer integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: jury_trivia_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jury_trivia_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jury_trivia_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jury_trivia_answers_id_seq OWNED BY jury_trivia_answers.id;


--
-- Name: jury_trivia_questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jury_trivia_questions (
    id integer NOT NULL,
    jury_game_id integer NOT NULL,
    question text NOT NULL,
    answer character varying(255) NOT NULL,
    wrong_answer_1 character varying(255) NOT NULL,
    wrong_answer_2 character varying(255) NOT NULL,
    wrong_answer_3 character varying(255) NOT NULL,
    follow_up_factoid text,
    difficulty integer DEFAULT 0,
    flags integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: jury_trivia_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jury_trivia_questions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: jury_trivia_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jury_trivia_questions_id_seq OWNED BY jury_trivia_questions.id;


--
-- Name: lazona_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lazona_users (
    id integer NOT NULL,
    user_id integer NOT NULL,
    lazona_uid character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_imported boolean DEFAULT false NOT NULL
);


--
-- Name: lazona_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lazona_users_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: lazona_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lazona_users_id_seq OWNED BY lazona_users.id;


--
-- Name: letters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE letters (
    id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    subject character varying(255) NOT NULL,
    to_whom character varying(255),
    cc_whom character varying(255),
    bcc_whom character varying(255),
    awol character varying(255),
    sent boolean DEFAULT false NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    content text,
    regarding_id integer,
    see_entry_id integer,
    see_media_id integer,
    letter_type integer DEFAULT 2 NOT NULL
);


--
-- Name: letters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE letters_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: letters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE letters_id_seq OWNED BY letters.id;


--
-- Name: license_agreements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE license_agreements (
    id integer NOT NULL,
    band_id integer NOT NULL,
    creator_id integer NOT NULL,
    start_at date NOT NULL,
    end_at date NOT NULL,
    canceled_at date,
    canceled_by_id integer,
    flags integer DEFAULT 0 NOT NULL,
    note_to_supervisors text,
    administrative_note text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    attachment_file_name character varying(255),
    attachment_content_type character varying(255),
    attachment_file_size integer,
    attachment_updated_at timestamp without time zone
);


--
-- Name: license_agreements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE license_agreements_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: license_agreements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE license_agreements_id_seq OWNED BY license_agreements.id;


--
-- Name: licensing_request_actions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE licensing_request_actions (
    id integer NOT NULL,
    licensing_request_id integer NOT NULL,
    user_id integer NOT NULL,
    status integer NOT NULL,
    note text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: licensing_request_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE licensing_request_actions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: licensing_request_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE licensing_request_actions_id_seq OWNED BY licensing_request_actions.id;


--
-- Name: licensing_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE licensing_requests (
    id integer NOT NULL,
    media_item_id integer NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: licensing_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE licensing_requests_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: licensing_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE licensing_requests_id_seq OWNED BY licensing_requests.id;


--
-- Name: limbo_battles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE limbo_battles (
    id integer NOT NULL,
    user_id integer NOT NULL,
    battle_type integer NOT NULL,
    entry_1_id integer NOT NULL,
    entry_2_id integer NOT NULL,
    entry_3_id integer,
    entry_4_id integer,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: limbo_battles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE limbo_battles_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: limbo_battles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE limbo_battles_id_seq OWNED BY limbo_battles.id;


--
-- Name: listing_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE listing_categories (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent_id integer,
    status integer DEFAULT 0 NOT NULL,
    price integer DEFAULT 0 NOT NULL,
    expiration integer DEFAULT 0 NOT NULL,
    user_level_requirement integer DEFAULT 0 NOT NULL,
    date integer DEFAULT 0 NOT NULL
);


--
-- Name: listing_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE listing_categories_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: listing_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE listing_categories_id_seq OWNED BY listing_categories.id;


--
-- Name: listing_genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE listing_genres (
    id integer NOT NULL,
    listing_id integer NOT NULL,
    genre_id integer NOT NULL
);


--
-- Name: listing_genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE listing_genres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: listing_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE listing_genres_id_seq OWNED BY listing_genres.id;


--
-- Name: listing_threads; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE listing_threads (
    id integer NOT NULL,
    listing_id integer NOT NULL,
    user_id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    seller_status integer DEFAULT 0 NOT NULL,
    buyer_status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: listing_threads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE listing_threads_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: listing_threads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE listing_threads_id_seq OWNED BY listing_threads.id;


--
-- Name: listings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE listings (
    id integer NOT NULL,
    headline character varying(255) NOT NULL,
    owner_id integer NOT NULL,
    key character varying(255) NOT NULL,
    description text NOT NULL,
    expiration date,
    status integer DEFAULT 2 NOT NULL,
    category_id integer NOT NULL,
    price double precision,
    longitude numeric(9,6),
    latitude numeric(9,6),
    city character varying(255),
    state character varying(255),
    country character varying(255),
    image_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    start_time timestamp without time zone,
    end_time timestamp without time zone
);


--
-- Name: listings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE listings_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: listings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE listings_id_seq OWNED BY listings.id;


--
-- Name: live_chat_rooms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE live_chat_rooms (
    id integer NOT NULL,
    flags integer DEFAULT 0,
    key character varying(40) NOT NULL,
    name character varying(80) NOT NULL,
    description character varying(255) DEFAULT NULL::character varying,
    title character varying(255) DEFAULT NULL::character varying,
    greeting character varying(255) DEFAULT NULL::character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer,
    permissions integer DEFAULT 0 NOT NULL
);


--
-- Name: live_chat_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE live_chat_rooms_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: live_chat_rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE live_chat_rooms_id_seq OWNED BY live_chat_rooms.id;


--
-- Name: live_feed_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE live_feed_items (
    id integer NOT NULL,
    snippet text NOT NULL,
    event_type integer DEFAULT 0 NOT NULL,
    media_type_id integer,
    subject_class_name character varying(255),
    subject_id integer,
    created_at timestamp without time zone NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    channel_id integer,
    artist_id integer,
    user_id integer,
    subject_2_class_name character varying(255),
    subject_2_id integer
);


--
-- Name: live_feed_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE live_feed_items_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: live_feed_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE live_feed_items_id_seq OWNED BY live_feed_items.id;


--
-- Name: live_user_states; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE live_user_states (
    id integer NOT NULL,
    user_id integer NOT NULL,
    ban_count integer DEFAULT 0,
    ban_until timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: live_user_states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE live_user_states_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: live_user_states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE live_user_states_id_seq OWNED BY live_user_states.id;


--
-- Name: locks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locks (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    owner character varying(255) NOT NULL
);


--
-- Name: locks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: locks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locks_id_seq OWNED BY locks.id;


--
-- Name: market_place_epks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE market_place_epks (
    id integer NOT NULL,
    user_id integer NOT NULL,
    band_name character varying(255) DEFAULT NULL::character varying,
    telephone character varying(255) DEFAULT NULL::character varying,
    members text,
    setup_requirements text,
    setlist text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    about_me text,
    status integer DEFAULT 0 NOT NULL,
    overview text,
    primary_genre_id integer,
    secondary_genre_id integer,
    stage_plot_id integer,
    live_performance_status integer DEFAULT 0,
    gig_agent_opt_out boolean DEFAULT false NOT NULL
);


--
-- Name: market_place_epks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE market_place_epks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: market_place_epks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE market_place_epks_id_seq OWNED BY market_place_epks.id;


--
-- Name: market_place_presses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE market_place_presses (
    id integer NOT NULL,
    epk_id integer,
    headline character varying(255) NOT NULL,
    body text NOT NULL,
    byline character varying(255) NOT NULL,
    link_url character varying(255) DEFAULT NULL::character varying,
    ordinal integer,
    venue_id integer
);


--
-- Name: market_place_presses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE market_place_presses_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: market_place_presses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE market_place_presses_id_seq OWNED BY market_place_presses.id;


--
-- Name: marketplace_applicant_payments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_applicant_payments (
    id integer NOT NULL,
    applicant_id integer NOT NULL,
    transaction_id character varying(20) DEFAULT NULL::character varying,
    gross numeric(8,2) DEFAULT 0,
    fee numeric(8,2) DEFAULT 0,
    raw_post text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: marketplace_applicant_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_applicant_payments_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_applicant_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_applicant_payments_id_seq OWNED BY marketplace_applicant_payments.id;


--
-- Name: marketplace_applicants; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_applicants (
    id integer NOT NULL,
    artist_id integer NOT NULL,
    gig_id integer NOT NULL,
    flags integer DEFAULT 0,
    status integer,
    note text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    key character varying(12)
);


--
-- Name: marketplace_applicants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_applicants_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_applicants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_applicants_id_seq OWNED BY marketplace_applicants.id;


--
-- Name: marketplace_artist_info_answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_artist_info_answers (
    id integer NOT NULL,
    user_id integer,
    question_enum integer NOT NULL,
    value text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: marketplace_artist_info_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_artist_info_answers_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_artist_info_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_artist_info_answers_id_seq OWNED BY marketplace_artist_info_answers.id;


--
-- Name: marketplace_artist_scores; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_artist_scores (
    id integer NOT NULL,
    user_id integer NOT NULL,
    points integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: marketplace_artist_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_artist_scores_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_artist_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_artist_scores_id_seq OWNED BY marketplace_artist_scores.id;


--
-- Name: marketplace_channel_scores; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_channel_scores (
    id integer NOT NULL,
    points integer NOT NULL,
    user_id integer NOT NULL,
    channel_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    entry_id integer
);


--
-- Name: marketplace_channel_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_channel_scores_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_channel_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_channel_scores_id_seq OWNED BY marketplace_channel_scores.id;


--
-- Name: marketplace_contest_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_contest_categories (
    id integer NOT NULL,
    venue_id integer,
    ordinal integer,
    name character varying(255) DEFAULT NULL::character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: marketplace_contest_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_contest_categories_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_contest_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_contest_categories_id_seq OWNED BY marketplace_contest_categories.id;


--
-- Name: marketplace_contest_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_contest_items (
    id integer NOT NULL,
    applicant_id integer,
    media_item_id integer,
    category_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: marketplace_contest_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_contest_items_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_contest_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_contest_items_id_seq OWNED BY marketplace_contest_items.id;


--
-- Name: marketplace_venue_artist_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_venue_artist_categories (
    id integer NOT NULL,
    venue_id integer NOT NULL,
    artist_id integer NOT NULL,
    value integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: marketplace_evaluations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_evaluations_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_evaluations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_evaluations_id_seq OWNED BY marketplace_venue_artist_categories.id;


--
-- Name: marketplace_filters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_filters (
    id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    contents_hash bytea
);


--
-- Name: marketplace_filters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_filters_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_filters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_filters_id_seq OWNED BY marketplace_filters.id;


--
-- Name: marketplace_gig_actions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_gig_actions (
    id integer NOT NULL,
    gig_id integer NOT NULL,
    applicant_id integer NOT NULL,
    status integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: marketplace_gig_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_gig_actions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_gig_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_gig_actions_id_seq OWNED BY marketplace_gig_actions.id;


--
-- Name: marketplace_gig_agent_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_gig_agent_logs (
    id integer NOT NULL,
    gig_id integer,
    artist_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: marketplace_gig_agent_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_gig_agent_logs_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_gig_agent_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_gig_agent_logs_id_seq OWNED BY marketplace_gig_agent_logs.id;


--
-- Name: marketplace_gigs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_gigs (
    id integer NOT NULL,
    venue_id integer NOT NULL,
    event_id integer NOT NULL,
    deadline integer,
    notification integer,
    group_count integer,
    group_size integer,
    status integer,
    apply boolean,
    promote boolean,
    high_profile boolean,
    negotiated boolean,
    title character varying(255) DEFAULT NULL::character varying,
    gig_types character varying(255) DEFAULT NULL::character varying,
    uri character varying(255) DEFAULT NULL::character varying,
    compensation character varying(255) DEFAULT NULL::character varying,
    key character varying(12) DEFAULT NULL::character varying,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    apply_deadline date NOT NULL,
    notify_deadline date NOT NULL,
    expiration integer,
    flags integer DEFAULT 0,
    application_fee numeric(8,2) DEFAULT 0,
    application_requirements text
);


--
-- Name: marketplace_gigs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_gigs_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_gigs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_gigs_id_seq OWNED BY marketplace_gigs.id;


--
-- Name: marketplace_invites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_invites (
    id integer NOT NULL,
    inviter_id integer NOT NULL,
    invitee_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: marketplace_invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_invites_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_invites_id_seq OWNED BY marketplace_invites.id;


--
-- Name: marketplace_qualification_overrides; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_qualification_overrides (
    id integer NOT NULL,
    artist_id integer NOT NULL,
    gig_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: marketplace_qualification_overrides_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_qualification_overrides_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_qualification_overrides_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_qualification_overrides_id_seq OWNED BY marketplace_qualification_overrides.id;


--
-- Name: marketplace_venue_artist_rating_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_venue_artist_rating_comments (
    id integer NOT NULL,
    venue_id integer,
    artist_id integer,
    aggregate_rating double precision,
    comment character varying(90),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: marketplace_venue_artist_rating_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_venue_artist_rating_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_venue_artist_rating_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_venue_artist_rating_comments_id_seq OWNED BY marketplace_venue_artist_rating_comments.id;


--
-- Name: marketplace_venue_artist_ratings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_venue_artist_ratings (
    id integer NOT NULL,
    venue_id integer,
    artist_id integer,
    rating_type integer,
    rating integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: marketplace_venue_artist_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_venue_artist_ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_venue_artist_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_venue_artist_ratings_id_seq OWNED BY marketplace_venue_artist_ratings.id;


--
-- Name: marketplace_venue_artist_recommendations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_venue_artist_recommendations (
    id integer NOT NULL,
    venue_id integer,
    artist_id integer,
    recommendation_text text,
    is_public boolean DEFAULT false NOT NULL,
    is_reviewed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    first_name character varying(255),
    last_name character varying(255),
    role character varying(255)
);


--
-- Name: marketplace_venue_artist_recommendations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_venue_artist_recommendations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_venue_artist_recommendations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_venue_artist_recommendations_id_seq OWNED BY marketplace_venue_artist_recommendations.id;


--
-- Name: marketplace_venue_contacts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_venue_contacts (
    id integer NOT NULL,
    venue_id integer,
    contact_type_id integer,
    phone character varying(255),
    email character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: marketplace_venue_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_venue_contacts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_venue_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_venue_contacts_id_seq OWNED BY marketplace_venue_contacts.id;


--
-- Name: marketplace_venues; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE marketplace_venues (
    id integer NOT NULL,
    user_id integer NOT NULL,
    role integer NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    capacity integer,
    name character varying(80) NOT NULL,
    channels character varying(255),
    uri character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    directions text,
    stage_specs text,
    dining_info text,
    menu_img_id integer
);


--
-- Name: marketplace_venues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE marketplace_venues_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: marketplace_venues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE marketplace_venues_id_seq OWNED BY marketplace_venues.id;


--
-- Name: media_assets_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_assets_images (
    id integer NOT NULL,
    user_id integer NOT NULL,
    key character varying(12) NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    original_width integer DEFAULT 0 NOT NULL,
    original_height integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    original_file_name character varying(255),
    renditions character varying(255),
    name character varying(80) NOT NULL,
    config_class_name character varying(255) NOT NULL
);


--
-- Name: media_assets_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_assets_images_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: media_assets_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_assets_images_id_seq OWNED BY media_assets_images.id;


--
-- Name: media_item_license_agreements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_item_license_agreements (
    id integer NOT NULL,
    media_item_id integer NOT NULL,
    license_agreement_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    alternate_media_item_name character varying(80),
    creator_id integer,
    deleted_at timestamp without time zone,
    deleted_by integer
);


--
-- Name: media_item_license_agreements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_item_license_agreements_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: media_item_license_agreements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_item_license_agreements_id_seq OWNED BY media_item_license_agreements.id;


--
-- Name: media_item_play_counts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_item_play_counts (
    id integer NOT NULL,
    media_item_id integer,
    play_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: media_item_play_counts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_item_play_counts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: media_item_play_counts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_item_play_counts_id_seq OWNED BY media_item_play_counts.id;


--
-- Name: media_item_ratings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_item_ratings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    media_item_id integer NOT NULL,
    rating integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone
);


--
-- Name: media_item_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_item_ratings_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: media_item_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_item_ratings_id_seq OWNED BY media_item_ratings.id;


--
-- Name: media_item_stats; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_item_stats (
    media_item_id integer,
    category character varying(255),
    rating_avg numeric,
    rating_count bigint
);


--
-- Name: media_item_views; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_item_views (
    id integer NOT NULL,
    media_item_id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    view_type integer NOT NULL,
    seconds_viewed integer NOT NULL
);


--
-- Name: media_item_views_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_item_views_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: media_item_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_item_views_id_seq OWNED BY media_item_views.id;


--
-- Name: media_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_items (
    id integer NOT NULL,
    name character varying(80),
    media_file character varying(255),
    dst_format character varying(12),
    media_type_id integer NOT NULL,
    user_id integer NOT NULL,
    key character varying(12) NOT NULL,
    duration integer DEFAULT 0,
    file_bytes integer DEFAULT 0,
    status integer NOT NULL,
    description character varying(512),
    review_status integer DEFAULT 0,
    created_at timestamp without time zone,
    disqualified integer DEFAULT 0,
    artist character varying(80),
    album character varying(80),
    allow_site_usage boolean DEFAULT false,
    thumb_file character varying(255),
    media_width integer,
    media_height integer,
    thumb_width integer,
    thumb_height integer,
    hi_fi_media_file character varying(255),
    hi_fi_media_width integer,
    hi_fi_media_height integer,
    weed integer DEFAULT 0 NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    ordinal integer,
    lyrics text,
    explicit boolean,
    band_id integer,
    updated_at timestamp without time zone
);


--
-- Name: media_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_items_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: media_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_items_id_seq OWNED BY media_items.id;


--
-- Name: media_market_zipcodes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_market_zipcodes (
    id integer NOT NULL,
    zipcode character varying(5) NOT NULL,
    media_market_id integer NOT NULL,
    state_code integer,
    state character varying(255),
    city_code integer,
    city character varying(255)
);


--
-- Name: media_market_zipcodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_market_zipcodes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: media_market_zipcodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_market_zipcodes_id_seq OWNED BY media_market_zipcodes.id;


--
-- Name: media_markets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_markets (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    market_type integer NOT NULL,
    rank integer,
    source character varying(255) DEFAULT 'NIELSEN'::character varying NOT NULL,
    code character varying(255)
);


--
-- Name: media_markets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_markets_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: media_markets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_markets_id_seq OWNED BY media_markets.id;


--
-- Name: message_blockers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE message_blockers (
    id integer NOT NULL,
    user_id integer NOT NULL,
    blocked_id integer NOT NULL,
    blocked_name character varying(255),
    reason character varying(255),
    created_at timestamp without time zone NOT NULL
);


--
-- Name: message_blockers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE message_blockers_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: message_blockers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE message_blockers_id_seq OWNED BY message_blockers.id;


--
-- Name: message_templates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE message_templates (
    id integer NOT NULL,
    en_message text,
    es_message text,
    name character varying(255) NOT NULL,
    item_type integer,
    action_type integer
);


--
-- Name: message_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE message_templates_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: message_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE message_templates_id_seq OWNED BY message_templates.id;


--
-- Name: messages_blasts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE messages_blasts (
    id integer NOT NULL,
    user_id integer NOT NULL,
    filter character varying(255),
    subject character varying(255) NOT NULL,
    text text NOT NULL,
    activate_at timestamp without time zone NOT NULL,
    expire_at timestamp without time zone NOT NULL,
    no_reply boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: messages_blasts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_blasts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: messages_blasts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_blasts_id_seq OWNED BY messages_blasts.id;


--
-- Name: messages_blastvelopes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE messages_blastvelopes (
    id integer NOT NULL,
    user_id integer NOT NULL,
    blast_id integer NOT NULL,
    unread boolean DEFAULT true NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: messages_blastvelopes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_blastvelopes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: messages_blastvelopes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_blastvelopes_id_seq OWNED BY messages_blastvelopes.id;


--
-- Name: messages_conversations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE messages_conversations (
    id integer NOT NULL,
    subject character varying(255),
    members character varying(255),
    context character varying(255),
    context_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: messages_conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_conversations_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: messages_conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_conversations_id_seq OWNED BY messages_conversations.id;


--
-- Name: messages_envelopes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE messages_envelopes (
    id integer NOT NULL,
    user_id integer NOT NULL,
    conversation_id integer NOT NULL,
    unread_count integer DEFAULT 0 NOT NULL,
    last_message_at timestamp without time zone NOT NULL
);


--
-- Name: messages_envelopes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_envelopes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: messages_envelopes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_envelopes_id_seq OWNED BY messages_envelopes.id;


--
-- Name: messages_letters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE messages_letters (
    id integer NOT NULL,
    user_id integer NOT NULL,
    conversation_id integer NOT NULL,
    text character varying(4096),
    created_at timestamp without time zone NOT NULL
);


--
-- Name: messages_letters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_letters_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: messages_letters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_letters_id_seq OWNED BY messages_letters.id;


--
-- Name: microsite_bunchball_trophies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE microsite_bunchball_trophies (
    id integer NOT NULL,
    name character varying(255),
    regexp character varying(255),
    suppress_until_earned boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: microsite_bunchball_trophies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE microsite_bunchball_trophies_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: microsite_bunchball_trophies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE microsite_bunchball_trophies_id_seq OWNED BY microsite_bunchball_trophies.id;


--
-- Name: microsite_domains; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE microsite_domains (
    id integer NOT NULL,
    domain character varying(255),
    active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: microsite_domains_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE microsite_domains_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: microsite_domains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE microsite_domains_id_seq OWNED BY microsite_domains.id;


--
-- Name: mojos_best_of_artists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mojos_best_of_artists (
    id integer NOT NULL,
    artist_id integer NOT NULL,
    value double precision NOT NULL
);


--
-- Name: mojos_best_of_artists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mojos_best_of_artists_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: mojos_best_of_artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mojos_best_of_artists_id_seq OWNED BY mojos_best_of_artists.id;


--
-- Name: mojos_best_of_genre_artists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mojos_best_of_genre_artists (
    id integer NOT NULL,
    artist_id integer NOT NULL,
    value double precision NOT NULL,
    genre character varying(255) NOT NULL
);


--
-- Name: mojos_best_of_genre_artists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mojos_best_of_genre_artists_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: mojos_best_of_genre_artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mojos_best_of_genre_artists_id_seq OWNED BY mojos_best_of_genre_artists.id;


--
-- Name: mojos_best_of_tracks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mojos_best_of_tracks (
    id integer NOT NULL,
    media_item_id integer NOT NULL,
    value double precision NOT NULL
);


--
-- Name: mojos_best_of_tracks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mojos_best_of_tracks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: mojos_best_of_tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mojos_best_of_tracks_id_seq OWNED BY mojos_best_of_tracks.id;


--
-- Name: mojos_external_artist_data; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mojos_external_artist_data (
    id integer NOT NULL,
    user_id integer NOT NULL,
    klass integer NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    synced_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    int_data integer,
    float_data double precision
);


--
-- Name: mojos_external_artist_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mojos_external_artist_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: mojos_external_artist_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mojos_external_artist_data_id_seq OWNED BY mojos_external_artist_data.id;


--
-- Name: network_companies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE network_companies (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    key character varying(12) NOT NULL,
    user_id integer,
    creator_id integer,
    parent_company_id integer,
    locked boolean DEFAULT false,
    deleted boolean DEFAULT false,
    deleted_by integer,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: network_companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE network_companies_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: network_companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE network_companies_id_seq OWNED BY network_companies.id;


--
-- Name: network_company_labels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE network_company_labels (
    id integer NOT NULL,
    company_id integer NOT NULL,
    label_id integer NOT NULL,
    creator_id integer,
    start_date character varying(8),
    end_date character varying(8),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: network_company_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE network_company_labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: network_company_labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE network_company_labels_id_seq OWNED BY network_company_labels.id;


--
-- Name: network_essay_revisions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE network_essay_revisions (
    id integer NOT NULL,
    body text,
    essay_id integer NOT NULL,
    user_id integer NOT NULL,
    deleted boolean DEFAULT false,
    deleted_by integer,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone
);


--
-- Name: network_essay_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE network_essay_revisions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: network_essay_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE network_essay_revisions_id_seq OWNED BY network_essay_revisions.id;


--
-- Name: network_essays; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE network_essays (
    id integer NOT NULL,
    network_object_id integer NOT NULL,
    network_object_type character varying(64) NOT NULL,
    current_revision_id integer,
    essay_type integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: network_essays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE network_essays_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: network_essays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE network_essays_id_seq OWNED BY network_essays.id;


--
-- Name: network_galleries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE network_galleries (
    id integer NOT NULL,
    network_object_id integer NOT NULL,
    network_object_type character varying(64) NOT NULL,
    cover_art_id integer,
    gallery_type integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: network_galleries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE network_galleries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: network_galleries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE network_galleries_id_seq OWNED BY network_galleries.id;


--
-- Name: network_gallery_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE network_gallery_items (
    id integer NOT NULL,
    gallery_id integer NOT NULL,
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    image_updated_at timestamp without time zone,
    user_id integer NOT NULL,
    deleted boolean DEFAULT false,
    deleted_by integer,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: network_gallery_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE network_gallery_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: network_gallery_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE network_gallery_items_id_seq OWNED BY network_gallery_items.id;


--
-- Name: network_labels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE network_labels (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    key character varying(12) NOT NULL,
    user_id integer,
    creator_id integer,
    parent_label_id integer,
    locked boolean DEFAULT false,
    deleted boolean DEFAULT false,
    deleted_by integer,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: network_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE network_labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: network_labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE network_labels_id_seq OWNED BY network_labels.id;


--
-- Name: network_uris; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE network_uris (
    id integer NOT NULL,
    uri character varying(255),
    network_object_id integer NOT NULL,
    network_object_type character varying(64) NOT NULL,
    uri_type integer,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: network_uris_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE network_uris_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: network_uris_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE network_uris_id_seq OWNED BY network_uris.id;


--
-- Name: new_banner_hits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE new_banner_hits (
    id integer NOT NULL,
    item_type integer,
    item character varying(255),
    style integer DEFAULT 0 NOT NULL,
    referrer character varying(255),
    action integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: new_banner_hits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE new_banner_hits_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: new_banner_hits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE new_banner_hits_id_seq OWNED BY new_banner_hits.id;


--
-- Name: new_fans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE new_fans_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: new_fans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE new_fans_id_seq OWNED BY fans.id;


--
-- Name: nominees; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE nominees (
    id integer NOT NULL,
    user_id integer NOT NULL,
    band_id integer NOT NULL,
    contest_id integer NOT NULL,
    active boolean NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: nominees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE nominees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: nominees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE nominees_id_seq OWNED BY nominees.id;


--
-- Name: onliners; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE onliners (
    id integer NOT NULL,
    user_id integer NOT NULL,
    activity integer NOT NULL,
    parameters character varying(1024) DEFAULT NULL::character varying,
    user_level integer NOT NULL,
    ip_addr character varying(255) NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: onliners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE onliners_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: onliners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE onliners_id_seq OWNED BY onliners.id;


--
-- Name: our_locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE our_locations (
    id integer NOT NULL,
    user_id integer NOT NULL,
    visibility integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    longitude numeric(9,6) DEFAULT NULL::numeric,
    latitude numeric(9,6) DEFAULT NULL::numeric,
    location_modifier numeric(9,6) DEFAULT NULL::numeric,
    name character varying(80) DEFAULT NULL::character varying NOT NULL,
    street character varying(80) DEFAULT NULL::character varying,
    street2 character varying(80) DEFAULT NULL::character varying,
    city character varying(80) DEFAULT NULL::character varying,
    state character varying(10) DEFAULT NULL::character varying,
    country character varying(10) DEFAULT NULL::character varying,
    zip character varying(20) DEFAULT NULL::character varying,
    phone_number character varying(30) DEFAULT NULL::character varying,
    web_uri character varying(255) DEFAULT NULL::character varying,
    key character varying(12),
    region character varying(80)
);


--
-- Name: our_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE our_locations_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: our_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE our_locations_id_seq OWNED BY our_locations.id;


--
-- Name: ourcal_calendars; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ourcal_calendars (
    id integer NOT NULL,
    user_id integer NOT NULL,
    ordinal integer,
    access integer DEFAULT 128,
    display_ct integer DEFAULT 10,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    timezone character varying(30),
    name character varying(40)
);


--
-- Name: ourcal_calendars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ourcal_calendars_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ourcal_calendars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ourcal_calendars_id_seq OWNED BY ourcal_calendars.id;


--
-- Name: ourcal_event_locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ourcal_event_locations (
    id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    name character varying(255),
    street character varying(255),
    city character varying(255),
    state character varying(255),
    zip character varying(255),
    phone character varying(255)
);


--
-- Name: ourcal_event_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ourcal_event_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ourcal_event_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ourcal_event_locations_id_seq OWNED BY ourcal_event_locations.id;


--
-- Name: ourcal_events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ourcal_events (
    id integer NOT NULL,
    user_id integer NOT NULL,
    parent_calendar_id integer,
    access integer DEFAULT 0,
    typ integer DEFAULT 0,
    all_day integer DEFAULT 0,
    repeat_type integer DEFAULT 1,
    repeat_interval integer DEFAULT 1,
    repeat_units integer DEFAULT 1,
    repeat_end_count integer DEFAULT 1,
    repeat_end_at timestamp without time zone,
    local_repeat_end_at timestamp without time zone,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    local_start_time timestamp without time zone,
    local_end_time timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    timezone character varying(30) DEFAULT 'America/New_York'::character varying NOT NULL,
    name character varying(80),
    notes text,
    our_location_id integer,
    poster_id integer,
    age integer DEFAULT 0 NOT NULL,
    fees character varying(255),
    ticket_uri character varying(255),
    key character varying(12) NOT NULL
);


--
-- Name: ourcal_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ourcal_events_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ourcal_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ourcal_events_id_seq OWNED BY ourcal_events.id;


--
-- Name: page_hits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE page_hits (
    id integer NOT NULL,
    owner_user_id integer,
    viewer_user_id integer,
    viewed_at timestamp without time zone,
    ip_addr character varying(255),
    referrer character varying(255),
    session_id character varying(255),
    page_viewed character varying(255)
);


--
-- Name: page_hits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE page_hits_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: page_hits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE page_hits_id_seq OWNED BY page_hits.id;


--
-- Name: partners; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE partners (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    logo_image character varying(255),
    web_site character varying(255),
    rep_email_address character varying(255)
);


--
-- Name: partners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE partners_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: partners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE partners_id_seq OWNED BY partners.id;


--
-- Name: pg_buffercache; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW pg_buffercache AS
    SELECT p.bufferid, p.relfilenode, p.reltablespace, p.reldatabase, p.relblocknumber, p.isdirty, p.usagecount FROM pg_buffercache_pages() p(bufferid integer, relfilenode oid, reltablespace oid, reldatabase oid, relblocknumber bigint, isdirty boolean, usagecount smallint);


--
-- Name: translated_strings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE translated_strings (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: phase_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phase_keys_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: phase_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE phase_keys_id_seq OWNED BY translated_strings.id;


--
-- Name: phases; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE phases (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    schedule_id integer NOT NULL,
    ordinal integer NOT NULL,
    num_judgeable integer,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    entry_selected boolean DEFAULT false NOT NULL,
    allows_four_up boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    hide_standings boolean DEFAULT false NOT NULL
);


--
-- Name: phases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phases_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: phases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE phases_id_seq OWNED BY phases.id;


--
-- Name: plaques; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE plaques (
    id integer NOT NULL,
    name character varying(255),
    file character varying(255),
    rank integer
);


--
-- Name: plaques_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE plaques_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: plaques_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE plaques_id_seq OWNED BY plaques.id;


--
-- Name: playlists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE playlists (
    id integer NOT NULL,
    key character varying(12) NOT NULL,
    name character varying(255) NOT NULL,
    fetcher_class character varying(255) NOT NULL,
    fetcher_arguments text,
    user_id integer,
    media_type_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    cover_art_id integer,
    archived boolean,
    private boolean
);


--
-- Name: playlists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE playlists_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: playlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE playlists_id_seq OWNED BY playlists.id;


--
-- Name: playlists_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE playlists_items (
    id integer NOT NULL,
    playlist_id integer NOT NULL,
    media_item_id integer NOT NULL,
    entry_id integer,
    ordinal integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone
);


--
-- Name: playlists_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE playlists_items_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: playlists_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE playlists_items_id_seq OWNED BY playlists_items.id;


--
-- Name: playlists_shared_supervision_playlists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE playlists_shared_supervision_playlists (
    id integer NOT NULL,
    user_id integer NOT NULL,
    playlist_id integer NOT NULL,
    permission character varying(255),
    ordinal integer DEFAULT 0 NOT NULL,
    state character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: playlists_shared_supervision_playlists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE playlists_shared_supervision_playlists_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: playlists_shared_supervision_playlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE playlists_shared_supervision_playlists_id_seq OWNED BY playlists_shared_supervision_playlists.id;


--
-- Name: playlists_to_players; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE playlists_to_players (
    id integer NOT NULL,
    player_id integer NOT NULL,
    playlist_id integer NOT NULL,
    ordinal integer
);


--
-- Name: playlists_to_players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE playlists_to_players_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: playlists_to_players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE playlists_to_players_id_seq OWNED BY playlists_to_players.id;


--
-- Name: playlists_user_playlists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE playlists_user_playlists (
    id integer NOT NULL,
    user_id integer NOT NULL,
    playlist_id integer NOT NULL,
    playlist_type integer DEFAULT 0 NOT NULL,
    ordinal integer
);


--
-- Name: playlists_user_playlists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE playlists_user_playlists_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: playlists_user_playlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE playlists_user_playlists_id_seq OWNED BY playlists_user_playlists.id;


--
-- Name: points_item_offers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE points_item_offers (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    enabled boolean DEFAULT false,
    point_cost integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    limit_per_user integer NOT NULL,
    limit_global integer NOT NULL,
    show_limit_per_user boolean DEFAULT true,
    show_limit_global boolean DEFAULT true,
    number_sold integer DEFAULT 0,
    bunchball_action character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: points_item_offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE points_item_offers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: points_item_offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE points_item_offers_id_seq OWNED BY points_item_offers.id;


--
-- Name: points_item_purchases; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE points_item_purchases (
    id integer NOT NULL,
    item_offer_id integer NOT NULL,
    user_id integer NOT NULL,
    points_paid integer NOT NULL,
    bunchball_status integer DEFAULT 0 NOT NULL,
    bunchball_updated_at timestamp without time zone,
    fulfillment_status integer DEFAULT 0 NOT NULL,
    fulfillment_updated_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: points_item_purchases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE points_item_purchases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: points_item_purchases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE points_item_purchases_id_seq OWNED BY points_item_purchases.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE posts (
    id integer NOT NULL,
    user_id integer NOT NULL,
    perm_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    post_type character varying(255) NOT NULL,
    title character varying(255),
    url character varying(255),
    source character varying(255),
    body text,
    embed_code text,
    status integer DEFAULT 0 NOT NULL
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: predictors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE predictors (
    id integer NOT NULL,
    user_id integer NOT NULL,
    contest_id integer NOT NULL,
    month date NOT NULL,
    total_correct integer DEFAULT 0,
    total_battles integer DEFAULT 0,
    contest_size integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: predictors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE predictors_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: predictors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE predictors_id_seq OWNED BY predictors.id;


--
-- Name: prize_winners; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prize_winners (
    id integer NOT NULL,
    feature_item_id integer NOT NULL,
    user_id integer NOT NULL,
    entry_id integer,
    admin_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fulfilled_at timestamp without time zone,
    fulfiller_id integer,
    display_name character varying(255)
);


--
-- Name: prize_winners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prize_winners_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: prize_winners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE prize_winners_id_seq OWNED BY prize_winners.id;


--
-- Name: profile_page_rollups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE profile_page_rollups (
    id integer NOT NULL,
    user_id integer,
    views integer,
    known_viewers integer,
    anon_viewers integer,
    roll_type integer,
    roll_date date
);


--
-- Name: profile_page_rollups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE profile_page_rollups_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: profile_page_rollups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE profile_page_rollups_id_seq OWNED BY profile_page_rollups.id;


--
-- Name: promo_data_judge_clicks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE promo_data_judge_clicks (
    id integer NOT NULL,
    ip character varying(255),
    media_key character varying(255),
    click_action character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    referrer character varying(255),
    promotion_id integer
);


--
-- Name: promo_data_judge_clicks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE promo_data_judge_clicks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: promo_data_judge_clicks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE promo_data_judge_clicks_id_seq OWNED BY promo_data_judge_clicks.id;


--
-- Name: promo_download_authorizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE promo_download_authorizations (
    id integer NOT NULL,
    promo_which_requires_login_id integer NOT NULL,
    promo_which_allows_access_id integer NOT NULL
);


--
-- Name: promo_download_authorizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE promo_download_authorizations_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: promo_download_authorizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE promo_download_authorizations_id_seq OWNED BY promo_download_authorizations.id;


--
-- Name: promotion_user_data; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE promotion_user_data (
    id integer NOT NULL,
    user_id integer NOT NULL,
    promotion_user_data_field_id integer NOT NULL,
    value character varying(255) NOT NULL
);


--
-- Name: promotion_user_data_fields; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE promotion_user_data_fields (
    id integer NOT NULL,
    promotion_id integer NOT NULL,
    name character varying(255) NOT NULL,
    datatype integer DEFAULT 0 NOT NULL,
    flags integer DEFAULT 3 NOT NULL,
    description text,
    key character varying(255)
);


--
-- Name: promotion_user_data_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE promotion_user_data_fields_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: promotion_user_data_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE promotion_user_data_fields_id_seq OWNED BY promotion_user_data_fields.id;


--
-- Name: promotion_user_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE promotion_user_data_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: promotion_user_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE promotion_user_data_id_seq OWNED BY promotion_user_data.id;


--
-- Name: promotions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE promotions (
    id integer NOT NULL,
    partner_id integer NOT NULL,
    name character varying(255),
    code character varying(255),
    created_at timestamp without time zone,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    logo_image character varying(255),
    banner_image character varying(255),
    intro_text text,
    instruction_text text,
    legal_text text,
    reward_text text,
    reward_image character varying(255),
    use_landing_page boolean DEFAULT true,
    redirect_media_type_id integer,
    redirect_channel_id integer,
    redirect_to_judging boolean DEFAULT false,
    landing_type integer DEFAULT 0,
    url_for_redirect character varying(255),
    give_free_music boolean DEFAULT false,
    charity_multiplier integer DEFAULT 0 NOT NULL,
    requires_login boolean DEFAULT false,
    flags integer DEFAULT 0 NOT NULL,
    custom_tos_url character varying(255),
    rep_email_address character varying(255),
    title character varying(75),
    description character varying(150),
    manager_id integer,
    co_branding_id integer,
    do_not_track_user boolean DEFAULT false NOT NULL,
    age_verification_class character varying(255),
    header_content text
);


--
-- Name: promotions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE promotions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: promotions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE promotions_id_seq OWNED BY promotions.id;


--
-- Name: purchasable_codes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE purchasable_codes (
    id integer NOT NULL,
    ecommerce_inventory_item_id integer NOT NULL,
    code character varying(255) NOT NULL,
    redeemed_at timestamp without time zone,
    user_id integer,
    ecommerce_invoice_item_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    claimed_at timestamp without time zone,
    reserved_at date,
    reserved_until date,
    reserved_for integer,
    reservation_note character varying(255),
    expires_at date
);


--
-- Name: purchasable_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE purchasable_codes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: purchasable_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE purchasable_codes_id_seq OWNED BY purchasable_codes.id;


--
-- Name: qaos_last_battle_processed; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE qaos_last_battle_processed (
    scored_at timestamp without time zone
);


--
-- Name: qaos_temp_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE qaos_temp_entries (
    contest_id integer,
    entry_id integer,
    score integer,
    score_adjustment integer,
    num_battles integer
);


--
-- Name: qaos_user_entry_scores; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE qaos_user_entry_scores (
    id integer NOT NULL,
    user_id integer NOT NULL,
    contest_id integer NOT NULL,
    entry_id integer NOT NULL,
    phase integer NOT NULL,
    score integer NOT NULL,
    ups integer NOT NULL,
    downs integer NOT NULL
);


--
-- Name: qaos_user_entry_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE qaos_user_entry_scores_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: qaos_user_entry_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE qaos_user_entry_scores_id_seq OWNED BY qaos_user_entry_scores.id;


--
-- Name: radio_settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE radio_settings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    popularity integer DEFAULT 75 NOT NULL,
    familiarity integer DEFAULT 10 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: radio_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE radio_settings_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: radio_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE radio_settings_id_seq OWNED BY radio_settings.id;


--
-- Name: ranks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ranks (
    id integer NOT NULL,
    rank_type integer DEFAULT 0,
    entry_id integer,
    ordinal integer,
    updated_at timestamp without time zone,
    contest_id integer
);


--
-- Name: ranks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ranks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ranks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ranks_id_seq OWNED BY ranks.id;


--
-- Name: recommendations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE recommendations (
    id integer NOT NULL,
    user_id integer NOT NULL,
    media_item_id integer NOT NULL,
    filter_id integer,
    rating integer,
    ds double precision,
    ds2 double precision,
    created_at timestamp without time zone,
    data text,
    play_time integer
);


--
-- Name: recommendations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recommendations_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: recommendations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recommendations_id_seq OWNED BY recommendations.id;


--
-- Name: recommendations_parameter_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE recommendations_parameter_groups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    min_ratings integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: recommendations_parameter_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recommendations_parameter_groups_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: recommendations_parameter_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recommendations_parameter_groups_id_seq OWNED BY recommendations_parameter_groups.id;


--
-- Name: recommendations_parameters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE recommendations_parameters (
    id integer NOT NULL,
    group_id integer NOT NULL,
    type character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    config text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    weight real DEFAULT 1.0 NOT NULL
);


--
-- Name: recommendations_parameters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recommendations_parameters_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: recommendations_parameters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recommendations_parameters_id_seq OWNED BY recommendations_parameters.id;


--
-- Name: recommended_artists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE recommended_artists (
    id integer NOT NULL,
    user_id integer NOT NULL,
    classify_genre_id integer NOT NULL,
    weight integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    locale character varying(255) DEFAULT 'en'::character varying NOT NULL,
    disqualified boolean DEFAULT false NOT NULL
);


--
-- Name: recommended_artists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recommended_artists_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: recommended_artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recommended_artists_id_seq OWNED BY recommended_artists.id;


--
-- Name: recommended_events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE recommended_events (
    id integer NOT NULL,
    events_event_id integer NOT NULL,
    classify_genre_id integer NOT NULL,
    date date NOT NULL,
    lng_int integer NOT NULL,
    lat_int integer NOT NULL,
    weight integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    locale character varying(255) DEFAULT 'en'::character varying NOT NULL,
    disqualified boolean DEFAULT false NOT NULL
);


--
-- Name: recommended_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recommended_events_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: recommended_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recommended_events_id_seq OWNED BY recommended_events.id;


--
-- Name: recommended_songs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE recommended_songs (
    id integer NOT NULL,
    media_item_id integer NOT NULL,
    media_type_id integer NOT NULL,
    classify_genre_id integer NOT NULL,
    weight integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    locale character varying(255) DEFAULT 'en'::character varying NOT NULL,
    disqualified boolean DEFAULT false NOT NULL
);


--
-- Name: recommended_songs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recommended_songs_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: recommended_songs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recommended_songs_id_seq OWNED BY recommended_songs.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE regions (
    id integer NOT NULL,
    ordinal integer DEFAULT 0,
    name character varying(255) NOT NULL,
    description character varying(255),
    postal_countries character varying(255),
    postal_regions character varying(255),
    postal_states character varying(255),
    region_type integer DEFAULT (-1) NOT NULL,
    cities character varying(255),
    longitude numeric(9,6),
    latitude numeric(9,6),
    radius integer
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE regions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE regions_id_seq OWNED BY regions.id;


--
-- Name: remote_contests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE remote_contests (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    image character varying(255) NOT NULL,
    description text,
    facebook_api_key_id integer,
    promotion_id integer,
    html_block text,
    link_block text,
    news_feed_image character varying(255),
    news_feed_caption character varying(255),
    small_image character varying(255),
    style_block text,
    background_type character varying(255) DEFAULT 'light'::character varying NOT NULL,
    judge_type integer DEFAULT 4 NOT NULL,
    extra_options text
);


--
-- Name: remote_contests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE remote_contests_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: remote_contests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE remote_contests_id_seq OWNED BY remote_contests.id;


--
-- Name: requested_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE requested_items (
    id integer NOT NULL,
    user_id integer,
    entry_id integer,
    media_item_id integer NOT NULL,
    has_been_notified boolean DEFAULT false,
    created_at timestamp without time zone
);


--
-- Name: requested_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE requested_items_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: requested_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE requested_items_id_seq OWNED BY requested_items.id;


--
-- Name: rev_share_defaults; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rev_share_defaults (
    id integer NOT NULL,
    user_id integer,
    rev_share_pcnt numeric,
    kitty_min numeric,
    kitty_max numeric,
    min_play_count integer,
    min_play_pcnt numeric,
    ignore_play_type text,
    ignore_referrer text,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    reason text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rev_share_defaults_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rev_share_defaults_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: rev_share_defaults_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rev_share_defaults_id_seq OWNED BY rev_share_defaults.id;


--
-- Name: rev_share_periods; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rev_share_periods (
    id integer NOT NULL,
    tier_set_id integer,
    flags integer DEFAULT 0,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    rev_share_pcnt numeric,
    kitty_min numeric,
    kitty_max numeric,
    kitty numeric DEFAULT 0.0,
    min_play_pcnt numeric,
    min_play_count integer,
    ignore_play_type text,
    ignore_referrer text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rev_share_periods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rev_share_periods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: rev_share_periods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rev_share_periods_id_seq OWNED BY rev_share_periods.id;


--
-- Name: rev_share_records; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rev_share_records (
    id integer NOT NULL,
    period_id integer NOT NULL,
    user_id integer NOT NULL,
    subscription_id integer NOT NULL,
    flags integer DEFAULT 0,
    qualified_plays integer DEFAULT 0,
    last_count timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rev_share_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rev_share_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: rev_share_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rev_share_records_id_seq OWNED BY rev_share_records.id;


--
-- Name: rev_share_rollups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rev_share_rollups (
    id integer NOT NULL,
    flags integer DEFAULT 0,
    period_id integer NOT NULL,
    user_id integer NOT NULL,
    qualified_playcount integer DEFAULT 0,
    earnings numeric DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rev_share_rollups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rev_share_rollups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: rev_share_rollups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rev_share_rollups_id_seq OWNED BY rev_share_rollups.id;


--
-- Name: rev_share_tier_sets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rev_share_tier_sets (
    id integer NOT NULL,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    user_id integer,
    reason text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rev_share_tier_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rev_share_tier_sets_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: rev_share_tier_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rev_share_tier_sets_id_seq OWNED BY rev_share_tier_sets.id;


--
-- Name: rev_share_tiers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rev_share_tiers (
    id integer NOT NULL,
    tier_set_id integer NOT NULL,
    ubound numeric DEFAULT 0,
    lbound numeric DEFAULT 1,
    kitty_share numeric NOT NULL
);


--
-- Name: rev_share_tiers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rev_share_tiers_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: rev_share_tiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rev_share_tiers_id_seq OWNED BY rev_share_tiers.id;


--
-- Name: role_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE role_groups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    restricted_access boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: role_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE role_groups_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: role_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE role_groups_id_seq OWNED BY role_groups.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    restricted_access boolean DEFAULT false,
    requires_confirmation boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    role_group_id integer
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: save_ranks_delete; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE save_ranks_delete (
    id integer,
    rank_type integer,
    entry_id integer,
    ordinal integer,
    updated_at timestamp without time zone
);


--
-- Name: scene_memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE scene_memberships (
    id integer NOT NULL,
    user_id integer NOT NULL,
    scene_id integer NOT NULL,
    moderator boolean DEFAULT false,
    banned boolean DEFAULT false,
    deleted boolean DEFAULT false,
    silenced boolean DEFAULT false,
    post_count integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: scene_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE scene_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: scene_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE scene_memberships_id_seq OWNED BY scene_memberships.id;


--
-- Name: scenes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE scenes (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(80) NOT NULL,
    key character varying(80) NOT NULL,
    is_members_only boolean DEFAULT true,
    is_invite_only boolean DEFAULT false,
    is_private boolean DEFAULT false,
    deleted boolean DEFAULT false,
    classify_genre_id integer,
    latitude numeric,
    longitude numeric,
    custom_options text,
    header_image_file_name character varying(255),
    header_image_content_type character varying(255),
    header_image_file_size integer,
    header_image_updated_at timestamp without time zone,
    icon_file_name character varying(255),
    icon_content_type character varying(255),
    icon_file_size integer,
    icon_updated_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    admin_only boolean DEFAULT false NOT NULL
);


--
-- Name: scenes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE scenes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: scenes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE scenes_id_seq OWNED BY scenes.id;


--
-- Name: schedules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schedules (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    ourstage_monthly boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schedules_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE schedules_id_seq OWNED BY schedules.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: score_factors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE score_factors (
    id integer NOT NULL,
    user_id integer NOT NULL,
    entry_id integer NOT NULL,
    klass integer NOT NULL,
    score integer NOT NULL,
    klass_data integer,
    disqualified integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: score_factors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE score_factors_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: score_factors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE score_factors_id_seq OWNED BY score_factors.id;


--
-- Name: scripts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE scripts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: scripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE scripts_id_seq OWNED BY games_talent_scripts.id;


--
-- Name: search_locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE search_locations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    longitude numeric(9,6) NOT NULL,
    latitude numeric(9,6) NOT NULL,
    event_density integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: search_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE search_locations_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: search_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE search_locations_id_seq OWNED BY search_locations.id;


--
-- Name: searched_strings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE searched_strings (
    id integer NOT NULL,
    the_string character varying(255) NOT NULL,
    user_id integer,
    created_at timestamp without time zone,
    ip_address character varying(255)
);


--
-- Name: searched_strings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE searched_strings_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: searched_strings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE searched_strings_id_seq OWNED BY searched_strings.id;


--
-- Name: send_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE send_items (
    id integer NOT NULL,
    item_id integer,
    sender_id integer,
    sender_name character varying(255),
    sender_email_address character varying(255),
    recipient_name character varying(255),
    recipient_email_address character varying(255),
    message text,
    item_type character varying(255) NOT NULL,
    recipient_count integer,
    created_at timestamp without time zone
);


--
-- Name: send_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE send_entries_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: send_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE send_entries_id_seq OWNED BY send_items.id;


--
-- Name: site_actions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE site_actions (
    id integer NOT NULL,
    admin_id integer,
    channel_id integer,
    action text,
    comment text,
    created_at timestamp without time zone
);


--
-- Name: site_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE site_actions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: site_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE site_actions_id_seq OWNED BY site_actions.id;


--
-- Name: site_visits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE site_visits (
    id integer NOT NULL,
    user_id integer NOT NULL,
    created_at date NOT NULL
);


--
-- Name: site_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE site_visits_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: site_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE site_visits_id_seq OWNED BY site_visits.id;


--
-- Name: sites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sites (
    id integer NOT NULL,
    local_hostname character varying(32) DEFAULT NULL::character varying,
    display_name character varying(64) DEFAULT NULL::character varying,
    title_bar_name character varying(64) DEFAULT NULL::character varying,
    promotion_id integer NOT NULL
);


--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sites_id_seq OWNED BY sites.id;


--
-- Name: sms_codes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sms_codes (
    id integer NOT NULL,
    prefix character varying(255),
    code character varying(255) NOT NULL,
    used boolean NOT NULL
);


--
-- Name: sms_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sms_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: sms_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sms_codes_id_seq OWNED BY sms_codes.id;


--
-- Name: sms_contests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sms_contests (
    id integer NOT NULL,
    channel_group_id integer,
    promotion_id integer,
    name character varying(255),
    description text,
    judgeable boolean DEFAULT false NOT NULL,
    enterable boolean DEFAULT false NOT NULL,
    visible boolean DEFAULT false NOT NULL,
    state integer NOT NULL,
    entry_restriction integer,
    entry_restriction_detail character varying(255),
    judge_start_date timestamp without time zone,
    judge_end_date timestamp without time zone,
    enter_start_date timestamp without time zone,
    enter_end_date timestamp without time zone,
    view_start_date timestamp without time zone,
    view_end_date timestamp without time zone,
    prefix character varying(255),
    phone_number character varying(255),
    call_to_action character varying(255),
    locale character varying(255) DEFAULT 'en'::character varying NOT NULL
);


--
-- Name: sms_contests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sms_contests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: sms_contests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sms_contests_id_seq OWNED BY sms_contests.id;


--
-- Name: sms_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sms_entries (
    id integer NOT NULL,
    sms_contest_id integer NOT NULL,
    user_id integer NOT NULL,
    key character varying(12) NOT NULL,
    item_klass character varying(255),
    item_id integer,
    sms_code character varying(255),
    rank integer,
    disqualified integer DEFAULT 0 NOT NULL,
    review_status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sms_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sms_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: sms_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sms_entries_id_seq OWNED BY sms_entries.id;


--
-- Name: stage_plot_elements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stage_plot_elements (
    id integer NOT NULL,
    stage_plot_id integer NOT NULL,
    ordinal integer NOT NULL,
    element_klass integer NOT NULL,
    name character varying(255) NOT NULL,
    extra_info text,
    x double precision NOT NULL,
    y double precision NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: stage_plot_elements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stage_plot_elements_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: stage_plot_elements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stage_plot_elements_id_seq OWNED BY stage_plot_elements.id;


--
-- Name: stage_plots; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stage_plots (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    ordinal integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    details text
);


--
-- Name: stage_plots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stage_plots_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: stage_plots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stage_plots_id_seq OWNED BY stage_plots.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subscriptions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    plan_id integer NOT NULL,
    bonus_songs integer,
    songs_remaining_this_period integer,
    date_subscribed timestamp without time zone NOT NULL,
    active_until timestamp without time zone NOT NULL,
    flags integer,
    status integer NOT NULL
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;


--
-- Name: subscriptions_plans; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subscriptions_plans (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    songs_per_month integer NOT NULL,
    bonus_songs_on_subscribe integer DEFAULT 0 NOT NULL,
    bonus_songs_on_upgrade integer DEFAULT 0 NOT NULL,
    price_per_month integer NOT NULL,
    upgradeable_to_id integer,
    flags integer,
    status integer
);


--
-- Name: subscriptions_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subscriptions_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: subscriptions_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subscriptions_plans_id_seq OWNED BY subscriptions_plans.id;


--
-- Name: subscriptions_purchased_songs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subscriptions_purchased_songs (
    id integer NOT NULL,
    user_id integer NOT NULL,
    media_item_id integer NOT NULL,
    plan_id integer NOT NULL,
    date_purchased timestamp without time zone NOT NULL,
    flags integer
);


--
-- Name: subscriptions_purchased_songs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subscriptions_purchased_songs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: subscriptions_purchased_songs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subscriptions_purchased_songs_id_seq OWNED BY subscriptions_purchased_songs.id;


--
-- Name: supervision_downloads; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE supervision_downloads (
    id integer NOT NULL,
    user_id integer NOT NULL,
    media_item_id integer NOT NULL,
    quality integer DEFAULT 0 NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: supervision_downloads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE supervision_downloads_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: supervision_downloads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE supervision_downloads_id_seq OWNED BY supervision_downloads.id;


--
-- Name: supervision_search_terms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE supervision_search_terms (
    id integer NOT NULL,
    supervision_search_id integer,
    term_type character varying(255),
    term_value character varying(255)
);


--
-- Name: supervision_search_terms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE supervision_search_terms_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: supervision_search_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE supervision_search_terms_id_seq OWNED BY supervision_search_terms.id;


--
-- Name: supervision_searches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE supervision_searches (
    id integer NOT NULL,
    user_id integer NOT NULL,
    results_count integer DEFAULT 0 NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: supervision_searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE supervision_searches_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: supervision_searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE supervision_searches_id_seq OWNED BY supervision_searches.id;


--
-- Name: supervisor_media_item_reviews; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE supervisor_media_item_reviews (
    id integer NOT NULL,
    user_id integer,
    media_item_id integer,
    good boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: supervisor_media_item_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE supervisor_media_item_reviews_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: supervisor_media_item_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE supervisor_media_item_reviews_id_seq OWNED BY supervisor_media_item_reviews.id;


--
-- Name: tag_counts_old; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tag_counts_old (
    id integer NOT NULL,
    item_type integer NOT NULL,
    item_id integer NOT NULL,
    tag_id integer NOT NULL,
    tag_count integer DEFAULT 1 NOT NULL
);


--
-- Name: tag_counts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tag_counts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: tag_counts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tag_counts_id_seq OWNED BY tag_counts_old.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer NOT NULL,
    taggable_id integer NOT NULL,
    tagger_id integer NOT NULL,
    tagger_type character varying(255) NOT NULL,
    taggable_type character varying(255) NOT NULL,
    context character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    weight integer
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: taggings_trusteds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings_trusteds (
    tag_id integer,
    taggable_type character varying(255),
    context character varying(255),
    taggable_id integer,
    weight bigint
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    key character varying(255),
    flags integer DEFAULT 0 NOT NULL
);


--
-- Name: tags_old; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags_old (
    id integer NOT NULL,
    creator_user_id integer NOT NULL,
    name character varying(80) NOT NULL,
    display_name character varying(80) NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags_old.id;


--
-- Name: tags_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: tags_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq1 OWNED BY tags.id;


--
-- Name: talent_battles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE talent_battles_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: talent_battles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE talent_battles_id_seq OWNED BY games_talent_battles.id;


--
-- Name: talent_games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE talent_games_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: talent_games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE talent_games_id_seq OWNED BY games_talent_games.id;


--
-- Name: talent_ranks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE talent_ranks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: talent_ranks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE talent_ranks_id_seq OWNED BY games_talent_ranks.id;


--
-- Name: talent_rounds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE talent_rounds_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: talent_rounds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE talent_rounds_id_seq OWNED BY games_talent_rounds.id;


--
-- Name: taste_space2_cluster_trees; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taste_space2_cluster_trees (
    id integer NOT NULL,
    space_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: taste_space2_cluster_trees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taste_space2_cluster_trees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: taste_space2_cluster_trees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taste_space2_cluster_trees_id_seq OWNED BY taste_space2_cluster_trees.id;


--
-- Name: taste_space2_clusters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taste_space2_clusters (
    id integer NOT NULL,
    cluster_tree_id integer NOT NULL,
    parent_id integer,
    lft integer,
    rgt integer,
    name character varying(255) NOT NULL,
    center_point_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: taste_space2_clusters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taste_space2_clusters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: taste_space2_clusters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taste_space2_clusters_id_seq OWNED BY taste_space2_clusters.id;


--
-- Name: taste_space2_disorders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taste_space2_disorders (
    id integer NOT NULL,
    space_id integer NOT NULL,
    item_id integer NOT NULL,
    disorder real NOT NULL
);


--
-- Name: taste_space2_disorders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taste_space2_disorders_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: taste_space2_disorders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taste_space2_disorders_id_seq OWNED BY taste_space2_disorders.id;


--
-- Name: taste_space2_points; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taste_space2_points (
    id integer NOT NULL,
    space_id integer NOT NULL,
    item_layer integer NOT NULL,
    item_id integer NOT NULL,
    mass real DEFAULT 1 NOT NULL,
    gravity real DEFAULT 1 NOT NULL,
    radius real DEFAULT 0 NOT NULL,
    c0 real DEFAULT 0 NOT NULL,
    c1 real DEFAULT 0 NOT NULL,
    c2 real DEFAULT 0 NOT NULL,
    c3 real DEFAULT 0 NOT NULL,
    c4 real DEFAULT 0 NOT NULL,
    c5 real DEFAULT 0 NOT NULL,
    c6 real DEFAULT 0 NOT NULL,
    c7 real DEFAULT 0 NOT NULL,
    c8 real DEFAULT 0 NOT NULL,
    c9 real DEFAULT 0 NOT NULL,
    c10 real DEFAULT 0 NOT NULL,
    c11 real DEFAULT 0 NOT NULL,
    c12 real DEFAULT 0 NOT NULL,
    c13 real DEFAULT 0 NOT NULL,
    c14 real DEFAULT 0 NOT NULL,
    c15 real DEFAULT 0 NOT NULL
);


--
-- Name: taste_space2_points_clusters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taste_space2_points_clusters (
    point_id integer NOT NULL,
    cluster_id integer NOT NULL
);


--
-- Name: taste_space2_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taste_space2_points_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: taste_space2_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taste_space2_points_id_seq OWNED BY taste_space2_points.id;


--
-- Name: taste_space2_spaces; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taste_space2_spaces (
    id integer NOT NULL,
    cluster_tree_id integer,
    owner_id integer,
    owner_class_name character varying(255),
    taste_space_class_name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    media_type_id integer
);


--
-- Name: taste_space2_spaces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taste_space2_spaces_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: taste_space2_spaces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taste_space2_spaces_id_seq OWNED BY taste_space2_spaces.id;


--
-- Name: taste_space_user_disorders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taste_space_user_disorders (
    id integer NOT NULL,
    layer_id integer NOT NULL,
    user_id integer NOT NULL,
    disorder real NOT NULL
);


--
-- Name: taste_space_user_disorders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taste_space_user_disorders_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: taste_space_user_disorders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taste_space_user_disorders_id_seq OWNED BY taste_space_user_disorders.id;


--
-- Name: thread_messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE thread_messages (
    id integer NOT NULL,
    thread_id integer NOT NULL,
    user_id integer NOT NULL,
    message text NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: thread_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE thread_messages_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: thread_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE thread_messages_id_seq OWNED BY thread_messages.id;


--
-- Name: travis_artist_stats; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE travis_artist_stats (
    id integer NOT NULL,
    user_id integer NOT NULL,
    region_id integer,
    demo_group_id integer,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    fans integer,
    friends integer,
    comments integer,
    dataset integer
);


--
-- Name: travis_artist_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE travis_artist_stats_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: travis_artist_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE travis_artist_stats_id_seq OWNED BY travis_artist_stats.id;


--
-- Name: travis_radio_format_channels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE travis_radio_format_channels (
    id integer NOT NULL,
    channel_id integer NOT NULL,
    travis_radio_format_id integer NOT NULL
);


--
-- Name: travis_radio_format_channels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE travis_radio_format_channels_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: travis_radio_format_channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE travis_radio_format_channels_id_seq OWNED BY travis_radio_format_channels.id;


--
-- Name: travis_radio_formats; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE travis_radio_formats (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying(255) NOT NULL
);


--
-- Name: travis_radio_formats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE travis_radio_formats_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: travis_radio_formats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE travis_radio_formats_id_seq OWNED BY travis_radio_formats.id;


--
-- Name: travis_track_stats; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE travis_track_stats (
    id integer NOT NULL,
    media_item_id integer NOT NULL,
    region_id integer,
    demo_group_id integer,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    plays integer,
    repeat_plays integer,
    judging_plays integer,
    complete_plays integer,
    players integer,
    repeat_players integer,
    rank integer,
    rating_sum integer,
    rating_count integer,
    comments integer,
    shared integer,
    favorites integer,
    dataset integer
);


--
-- Name: travis_track_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE travis_track_stats_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: travis_track_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE travis_track_stats_id_seq OWNED BY travis_track_stats.id;


--
-- Name: user_fb_event_pending_scrapes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_fb_event_pending_scrapes (
    id integer NOT NULL,
    user_id integer,
    fb_event_id character varying(255) NOT NULL,
    queued boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: user_fb_event_pending_scrapes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_fb_event_pending_scrapes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: user_fb_event_pending_scrapes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_fb_event_pending_scrapes_id_seq OWNED BY user_fb_event_pending_scrapes.id;


--
-- Name: user_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_groups (
    id integer NOT NULL,
    manager_id integer NOT NULL,
    grouping integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_groups_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_groups_id_seq OWNED BY user_groups.id;


--
-- Name: user_groups_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_groups_users (
    user_id integer NOT NULL,
    user_group_id integer NOT NULL,
    created_at timestamp without time zone
);


--
-- Name: user_infos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_infos (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permissions integer DEFAULT 2,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: user_infos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_infos_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: user_infos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_infos_id_seq OWNED BY user_infos.id;


--
-- Name: user_regions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_regions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    region_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_regions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: user_regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_regions_id_seq OWNED BY user_regions.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_roles (
    id integer NOT NULL,
    role_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_roles_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_roles_id_seq OWNED BY user_roles.id;


--
-- Name: user_tags_old; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_tags_old (
    id integer NOT NULL,
    user_id integer NOT NULL,
    item_type integer NOT NULL,
    item_id integer NOT NULL,
    tag_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: user_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_tags_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: user_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_tags_id_seq OWNED BY user_tags_old.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    first_name character varying(80),
    last_name character varying(80),
    hashed_password character varying(80),
    salt character varying(80),
    created_at timestamp without time zone,
    user_name character varying(80),
    display_name character varying(100),
    paypal_address character varying(255),
    web_address character varying(255),
    email_address character varying(255),
    original_email_address character varying(255),
    proposed_email_address character varying(255),
    postal_address_1 character varying(80),
    postal_address_2 character varying(80),
    postal_address_city character varying(80),
    postal_address_state character varying(10),
    postal_code character varying(20),
    postal_address_region character varying(80),
    postal_address_country character varying(10),
    phone_number character varying(30),
    wants_newsletter boolean,
    activation_code character varying(20),
    status integer,
    user_level integer DEFAULT 10,
    last_login_at timestamp without time zone,
    last_ip character varying(25),
    reg_ip character varying(25),
    promotion_id integer,
    t_shirt_size integer,
    forwards_letters boolean DEFAULT false,
    msg_per_page integer DEFAULT 12,
    cmt_per_page integer DEFAULT 6,
    pending_password character varying(40),
    flags integer DEFAULT 0,
    reg_user_agent character varying(255),
    last_user_agent character varying(255),
    activation_email_retry_count integer,
    judging_badge integer DEFAULT 0,
    info_uri character varying(255),
    ad_source character varying(255),
    ad_group character varying(255),
    ad_keyword character varying(255),
    referred_by character varying(255),
    longitude numeric,
    latitude numeric,
    location_modifier numeric,
    old_venue_name character varying(80),
    birth_year integer,
    sex character varying(255),
    referred_by_user_id integer,
    old_industry_profile integer,
    uri_element character varying(80),
    facebook_uid character varying(255),
    favorite_band_user_id integer,
    locale character varying(255),
    favorite_band_lockout timestamp without time zone,
    vanity_uri_element character varying(80)
);


--
-- Name: users_block_data_about_mes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_about_mes (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_about_mes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_about_mes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_about_mes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_about_mes_id_seq OWNED BY users_block_data_about_mes.id;


--
-- Name: users_block_data_achievement_lists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_achievement_lists (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_achievement_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_achievement_lists_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_achievement_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_achievement_lists_id_seq OWNED BY users_block_data_achievement_lists.id;


--
-- Name: users_block_data_artist_feeds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_artist_feeds (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_artist_feeds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_artist_feeds_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_artist_feeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_artist_feeds_id_seq OWNED BY users_block_data_artist_feeds.id;


--
-- Name: users_block_data_blogs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_blogs (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    flags integer DEFAULT 0 NOT NULL
);


--
-- Name: users_block_data_blogs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_blogs_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_blogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_blogs_id_seq OWNED BY users_block_data_blogs.id;


--
-- Name: users_block_data_comment_lists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_comment_lists (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_comment_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_comment_lists_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_comment_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_comment_lists_id_seq OWNED BY users_block_data_comment_lists.id;


--
-- Name: users_block_data_event_calendars; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_event_calendars (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone
);


--
-- Name: users_block_data_event_calendars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_event_calendars_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_event_calendars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_event_calendars_id_seq OWNED BY users_block_data_event_calendars.id;


--
-- Name: users_block_data_fan_lists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_fan_lists (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_fan_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_fan_lists_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_fan_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_fan_lists_id_seq OWNED BY users_block_data_fan_lists.id;


--
-- Name: users_block_data_fc_memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_fc_memberships (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_fc_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_fc_memberships_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_fc_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_fc_memberships_id_seq OWNED BY users_block_data_fc_memberships.id;


--
-- Name: users_block_data_firsts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_firsts (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status integer DEFAULT 0
);


--
-- Name: users_block_data_firsts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_firsts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_firsts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_firsts_id_seq OWNED BY users_block_data_firsts.id;


--
-- Name: users_block_data_free_tracks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_free_tracks (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_free_tracks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_free_tracks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_free_tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_free_tracks_id_seq OWNED BY users_block_data_free_tracks.id;


--
-- Name: users_block_data_friend_feeds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_friend_feeds (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_friend_feeds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_friend_feeds_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_friend_feeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_friend_feeds_id_seq OWNED BY users_block_data_friend_feeds.id;


--
-- Name: users_block_data_friend_lists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_friend_lists (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_friend_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_friend_lists_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_friend_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_friend_lists_id_seq OWNED BY users_block_data_friend_lists.id;


--
-- Name: users_block_data_influences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_influences (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_influences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_influences_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_influences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_influences_id_seq OWNED BY users_block_data_influences.id;


--
-- Name: users_block_data_judge_histories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_judge_histories (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    mode integer,
    flags integer
);


--
-- Name: users_block_data_judge_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_judge_histories_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_judge_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_judge_histories_id_seq OWNED BY users_block_data_judge_histories.id;


--
-- Name: users_block_data_link_boxes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_link_boxes (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_link_boxes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_link_boxes_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_link_boxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_link_boxes_id_seq OWNED BY users_block_data_link_boxes.id;


--
-- Name: users_block_data_live_feeds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_live_feeds (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_live_feeds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_live_feeds_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_live_feeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_live_feeds_id_seq OWNED BY users_block_data_live_feeds.id;


--
-- Name: users_block_data_media_item_lists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_media_item_lists (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_media_item_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_media_item_lists_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_media_item_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_media_item_lists_id_seq OWNED BY users_block_data_media_item_lists.id;


--
-- Name: users_block_data_music_favorites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_music_favorites (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_music_favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_music_favorites_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_music_favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_music_favorites_id_seq OWNED BY users_block_data_music_favorites.id;


--
-- Name: users_block_data_music_maps; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_music_maps (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_music_maps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_music_maps_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_music_maps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_music_maps_id_seq OWNED BY users_block_data_music_maps.id;


--
-- Name: users_block_data_music_players; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_music_players (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_music_players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_music_players_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_music_players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_music_players_id_seq OWNED BY users_block_data_music_players.id;


--
-- Name: users_block_data_my_accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_my_accounts (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_my_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_my_accounts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_my_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_my_accounts_id_seq OWNED BY users_block_data_my_accounts.id;


--
-- Name: users_block_data_photo_galleries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_photo_galleries (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_photo_galleries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_photo_galleries_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_photo_galleries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_photo_galleries_id_seq OWNED BY users_block_data_photo_galleries.id;


--
-- Name: users_block_data_stage_specs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_stage_specs (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    specs text
);


--
-- Name: users_block_data_stage_specs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_stage_specs_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_stage_specs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_stage_specs_id_seq OWNED BY users_block_data_stage_specs.id;


--
-- Name: users_block_data_venue_infos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_venue_infos (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    channels character varying(255) DEFAULT NULL::character varying,
    capacity character varying(255) DEFAULT NULL::character varying,
    url character varying(255) DEFAULT NULL::character varying,
    flags integer DEFAULT 0 NOT NULL
);


--
-- Name: users_block_data_venue_infos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_venue_infos_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_venue_infos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_venue_infos_id_seq OWNED BY users_block_data_venue_infos.id;


--
-- Name: users_block_data_video_favorites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_video_favorites (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_video_favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_video_favorites_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_video_favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_video_favorites_id_seq OWNED BY users_block_data_video_favorites.id;


--
-- Name: users_block_data_video_players; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_block_data_video_players (
    id integer NOT NULL,
    block_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_block_data_video_players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_block_data_video_players_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_block_data_video_players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_block_data_video_players_id_seq OWNED BY users_block_data_video_players.id;


--
-- Name: users_deferred_earnings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_deferred_earnings (
    id integer NOT NULL,
    user_id integer,
    invoice_id integer,
    cart_id integer,
    status integer DEFAULT 0,
    amount numeric,
    source character varying(255),
    note text,
    date_eligible date,
    date_granted date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_deferred_earnings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_deferred_earnings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_deferred_earnings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_deferred_earnings_id_seq OWNED BY users_deferred_earnings.id;


--
-- Name: users_demographics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_demographics (
    id integer NOT NULL,
    user_id integer NOT NULL,
    content_type character varying(255) NOT NULL,
    content_1 text,
    content_2 text,
    obj_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_demographics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_demographics_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_demographics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_demographics_id_seq OWNED BY users_demographics.id;


--
-- Name: users_donations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_donations (
    id integer NOT NULL,
    cart_id integer,
    donator_id integer,
    recipient_id integer,
    donation_amt_gross numeric,
    processing_fee numeric,
    donation_amt_net numeric,
    message character varying(255),
    anonymous boolean,
    cancelled boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_donations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_donations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_donations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_donations_id_seq OWNED BY users_donations.id;


--
-- Name: users_external_uris; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_external_uris (
    id integer NOT NULL,
    user_id integer NOT NULL,
    klass integer NOT NULL,
    uri character varying(255),
    text character varying(255),
    flags integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    last_event_scrape timestamp without time zone,
    is_junk boolean DEFAULT false NOT NULL
);


--
-- Name: users_external_uris_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_external_uris_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_external_uris_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_external_uris_id_seq OWNED BY users_external_uris.id;


--
-- Name: users_finance_rollups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_finance_rollups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    last_txn_id integer NOT NULL,
    balance numeric,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_finance_rollups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_finance_rollups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_finance_rollups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_finance_rollups_id_seq OWNED BY users_finance_rollups.id;


--
-- Name: users_finances; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_finances (
    id integer NOT NULL,
    user_id integer NOT NULL,
    transactor_id integer,
    transactor_type character varying(255),
    memo character varying(255),
    amount numeric DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_finances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_finances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_finances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_finances_id_seq OWNED BY users_finances.id;


--
-- Name: users_friendships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_friendships (
    id integer NOT NULL,
    user_id integer NOT NULL,
    friend_id integer NOT NULL,
    known_thru integer DEFAULT 0 NOT NULL,
    known_since date,
    status integer DEFAULT 0,
    handled_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL
);
ALTER TABLE ONLY users_friendships ALTER COLUMN user_id SET STATISTICS 300;
ALTER TABLE ONLY users_friendships ALTER COLUMN friend_id SET STATISTICS 300;


--
-- Name: users_friendships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_friendships_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_friendships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_friendships_id_seq OWNED BY users_friendships.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: users_photo_galleries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_photo_galleries (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(80) NOT NULL,
    description character varying(1000)
);


--
-- Name: users_photo_galleries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_photo_galleries_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_photo_galleries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_photo_galleries_id_seq OWNED BY users_photo_galleries.id;


--
-- Name: users_photo_gallery_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_photo_gallery_items (
    id integer NOT NULL,
    users_photo_gallery_id integer NOT NULL,
    media_assets_image_id integer NOT NULL,
    ordinal integer,
    description character varying(1000)
);


--
-- Name: users_photo_gallery_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_photo_gallery_items_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_photo_gallery_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_photo_gallery_items_id_seq OWNED BY users_photo_gallery_items.id;


--
-- Name: users_profile_blocks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_profile_blocks (
    id integer NOT NULL,
    page_id integer NOT NULL,
    section integer NOT NULL,
    ordinal integer,
    permissions integer DEFAULT 0,
    flags integer DEFAULT 0,
    block_class character varying(32) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_profile_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_profile_blocks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_profile_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_profile_blocks_id_seq OWNED BY users_profile_blocks.id;


--
-- Name: users_profile_links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_profile_links (
    id integer NOT NULL,
    profile_id integer NOT NULL,
    ordinal integer,
    text character varying(255),
    uri character varying(255)
);


--
-- Name: users_profile_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_profile_links_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_profile_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_profile_links_id_seq OWNED BY users_profile_links.id;


--
-- Name: users_profile_pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_profile_pages (
    id integer NOT NULL,
    profile_id integer NOT NULL,
    permissions integer DEFAULT 0 NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    layout_version integer
);


--
-- Name: users_profile_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_profile_pages_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_profile_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_profile_pages_id_seq OWNED BY users_profile_pages.id;


--
-- Name: users_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_profiles (
    id integer NOT NULL,
    user_id integer NOT NULL,
    description text,
    portrait_file character varying(255),
    portrait_file_caption character varying(255),
    birth_date date,
    gender integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    portrait_id integer,
    flags integer DEFAULT 0 NOT NULL,
    hometown character varying(255),
    birthday timestamp without time zone,
    birthday_visibility integer,
    relationship integer,
    relationship_visibility integer,
    education integer,
    education_visibility integer,
    identity integer,
    identity_visibility integer,
    income integer,
    income_visibility integer,
    custom_options text,
    header_image_file_name character varying(255),
    header_image_content_type character varying(255),
    header_image_file_size integer,
    header_image_updated_at timestamp without time zone,
    blackberry_pin character varying(8),
    facebook_page_id character varying(255),
    facebook_page_token character varying(255),
    donation_appeal text
);


--
-- Name: users_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_profiles_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_profiles_id_seq OWNED BY users_profiles.id;


--
-- Name: users_user_uris; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_user_uris (
    id integer NOT NULL,
    uri_element character varying(80) NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_user_uris_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_user_uris_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_user_uris_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_user_uris_id_seq OWNED BY users_user_uris.id;


--
-- Name: util_our_stats; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE util_our_stats (
    id integer NOT NULL,
    stat_date timestamp without time zone,
    tag character varying(255),
    stat_hash bytea
);


--
-- Name: util_our_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE util_our_stats_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: util_our_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE util_our_stats_id_seq OWNED BY util_our_stats.id;


--
-- Name: util_parameters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE util_parameters (
    id integer NOT NULL,
    data_class_name character varying(255) NOT NULL,
    data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    version integer DEFAULT 0 NOT NULL
);


--
-- Name: util_parameters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE util_parameters_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: util_parameters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE util_parameters_id_seq OWNED BY util_parameters.id;


--
-- Name: vote_records; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vote_records (
    id integer NOT NULL,
    keyword character varying(20) NOT NULL,
    msisdn character varying(20) NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    sequence integer NOT NULL,
    entry_id integer NOT NULL,
    created_at timestamp without time zone,
    valid boolean
);


--
-- Name: vote_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vote_records_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: vote_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vote_records_id_seq OWNED BY vote_records.id;


--
-- Name: welcome_page_emails; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE welcome_page_emails (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    promotion character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: welcome_page_emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE welcome_page_emails_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: welcome_page_emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE welcome_page_emails_id_seq OWNED BY welcome_page_emails.id;


--
-- Name: widget_giveaways; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE widget_giveaways (
    id integer NOT NULL,
    widget_id integer NOT NULL,
    giveaway_id integer NOT NULL
);


--
-- Name: widget_giveaways_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE widget_giveaways_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: widget_giveaways_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE widget_giveaways_id_seq OWNED BY widget_giveaways.id;


--
-- Name: widget_sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE widget_sessions (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    widget_key character varying(255) NOT NULL,
    referrer character varying(255),
    ip_addr character varying(255),
    user_agent character varying(255),
    phase integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: widget_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE widget_sessions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: widget_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE widget_sessions_id_seq OWNED BY widget_sessions.id;


--
-- Name: widgets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE widgets (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    ad_service character varying(255) DEFAULT NULL::character varying,
    ad_buy_description character varying(255) DEFAULT NULL::character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    click_tag character varying(255)
);


--
-- Name: widgets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE widgets_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: widgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE widgets_id_seq OWNED BY widgets.id;


--
-- Name: word_press_authors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE word_press_authors (
    id integer NOT NULL,
    user_id integer DEFAULT 0 NOT NULL,
    name character varying(255) NOT NULL,
    link_name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: word_press_authors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE word_press_authors_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: word_press_authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE word_press_authors_id_seq OWNED BY word_press_authors.id;


--
-- Name: word_press_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE word_press_categories (
    id integer NOT NULL,
    word_press_post_id integer NOT NULL,
    name character varying(255) NOT NULL,
    category character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: word_press_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE word_press_categories_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: word_press_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE word_press_categories_id_seq OWNED BY word_press_categories.id;


--
-- Name: word_press_posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE word_press_posts (
    id integer NOT NULL,
    word_press_author_id integer NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    title text NOT NULL,
    summary text NOT NULL,
    full_text text NOT NULL,
    word_press_url text NOT NULL,
    word_press_key character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    img_url character varying(255)
);


--
-- Name: word_press_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE word_press_posts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: word_press_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE word_press_posts_id_seq OWNED BY word_press_posts.id;


--
-- Name: word_press_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE word_press_tags (
    id integer NOT NULL,
    word_press_post_id integer NOT NULL,
    name character varying(255) NOT NULL,
    tag character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: word_press_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE word_press_tags_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: word_press_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE word_press_tags_id_seq OWNED BY word_press_tags.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE account_actions ALTER COLUMN id SET DEFAULT nextval('account_actions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE achievements ALTER COLUMN id SET DEFAULT nextval('achievements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE activation_requests ALTER COLUMN id SET DEFAULT nextval('activation_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE active_admin_comments ALTER COLUMN id SET DEFAULT nextval('admin_notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE administration_ignore_object_matches ALTER COLUMN id SET DEFAULT nextval('administration_ignore_object_matches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ads_ads ALTER COLUMN id SET DEFAULT nextval('ads_ads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ads_channel_groups ALTER COLUMN id SET DEFAULT nextval('ads_channel_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE anonymous_ratings ALTER COLUMN id SET DEFAULT nextval('anonymous_ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE anonymous_user_records ALTER COLUMN id SET DEFAULT nextval('anonymous_user_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE app_stuffs ALTER COLUMN id SET DEFAULT nextval('app_stuffs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE artist_accesses ALTER COLUMN id SET DEFAULT nextval('artist_accesses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE artist_referrals ALTER COLUMN id SET DEFAULT nextval('artist_referrals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE authnet_cim_payment_profiles ALTER COLUMN id SET DEFAULT nextval('authnet_cim_payment_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE authnet_cim_profiles ALTER COLUMN id SET DEFAULT nextval('authnet_cim_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE authnet_cim_shipping_profiles ALTER COLUMN id SET DEFAULT nextval('authnet_cim_shipping_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE authorizations ALTER COLUMN id SET DEFAULT nextval('authorizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE background_task_logs ALTER COLUMN id SET DEFAULT nextval('background_task_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE background_tasks ALTER COLUMN id SET DEFAULT nextval('background_tasks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE bad_ip_addresses ALTER COLUMN id SET DEFAULT nextval('bad_ip_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE bands ALTER COLUMN id SET DEFAULT nextval('bands_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE banner_hits ALTER COLUMN id SET DEFAULT nextval('banner_hits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE banner_themes ALTER COLUMN id SET DEFAULT nextval('banner_themes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE battle_behavior_ratings ALTER COLUMN id SET DEFAULT nextval('battle_behavior_ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE battle_influences ALTER COLUMN id SET DEFAULT nextval('battle_influences_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE battles ALTER COLUMN id SET DEFAULT nextval('battles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE beta_invitations ALTER COLUMN id SET DEFAULT nextval('beta_invitations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE blacklists ALTER COLUMN id SET DEFAULT nextval('blacklists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE build_statuses ALTER COLUMN id SET DEFAULT nextval('build_statuses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE bunchball_trophies ALTER COLUMN id SET DEFAULT nextval('bunchball_trophies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE bunchball_trophy_grants ALTER COLUMN id SET DEFAULT nextval('bunchball_trophy_grants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE canonical_artist_names ALTER COLUMN id SET DEFAULT nextval('canonical_artist_names_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE captchas ALTER COLUMN id SET DEFAULT nextval('captchas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE cart_items ALTER COLUMN id SET DEFAULT nextval('cart_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE carts ALTER COLUMN id SET DEFAULT nextval('carts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE catalog_item_photos ALTER COLUMN id SET DEFAULT nextval('catalog_item_photos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE catalog_items ALTER COLUMN id SET DEFAULT nextval('catalog_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE channel_genres ALTER COLUMN id SET DEFAULT nextval('channel_genres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE channel_groups ALTER COLUMN id SET DEFAULT nextval('channel_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE channel_views ALTER COLUMN id SET DEFAULT nextval('channel_views_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE channels ALTER COLUMN id SET DEFAULT nextval('channels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE chart_items ALTER COLUMN id SET DEFAULT nextval('chart_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE charts ALTER COLUMN id SET DEFAULT nextval('charts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE charts_best_of_best_approvals ALTER COLUMN id SET DEFAULT nextval('charts_best_of_best_approvals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE charts_best_of_best_genres ALTER COLUMN id SET DEFAULT nextval('charts_best_of_best_genres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE charts_categories ALTER COLUMN id SET DEFAULT nextval('charts_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE charts_charts ALTER COLUMN id SET DEFAULT nextval('charts_charts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE charts_positions ALTER COLUMN id SET DEFAULT nextval('charts_positions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE chats ALTER COLUMN id SET DEFAULT nextval('chats_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE checksums ALTER COLUMN id SET DEFAULT nextval('checksums_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE classify_competition_genres ALTER COLUMN id SET DEFAULT nextval('classify_competition_genres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE classify_genres ALTER COLUMN id SET DEFAULT nextval('classify_genres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE classify_media_item_genres ALTER COLUMN id SET DEFAULT nextval('classify_media_item_genres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE co_brandings ALTER COLUMN id SET DEFAULT nextval('co_brandings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE compete_competitions ALTER COLUMN id SET DEFAULT nextval('compete_competitions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE compete_entries ALTER COLUMN id SET DEFAULT nextval('compete_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE complaints ALTER COLUMN id SET DEFAULT nextval('complaints_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE completes ALTER COLUMN id SET DEFAULT nextval('completes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE contest_credit_transactions ALTER COLUMN id SET DEFAULT nextval('contest_credit_transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE contest_credits ALTER COLUMN id SET DEFAULT nextval('contest_credits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE contest_templates ALTER COLUMN id SET DEFAULT nextval('contest_templates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE contests ALTER COLUMN id SET DEFAULT nextval('contests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE custom_registrations ALTER COLUMN id SET DEFAULT nextval('custom_registrations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE demo_battles ALTER COLUMN id SET DEFAULT nextval('demo_battles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE demo_categories ALTER COLUMN id SET DEFAULT nextval('demo_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE demo_entry_statistics ALTER COLUMN id SET DEFAULT nextval('demo_entry_statistics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE demo_group_partitions ALTER COLUMN id SET DEFAULT nextval('demo_group_partitions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE demo_groups ALTER COLUMN id SET DEFAULT nextval('demo_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE demo_partitions ALTER COLUMN id SET DEFAULT nextval('demo_partitions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE demo_profile_groups ALTER COLUMN id SET DEFAULT nextval('demo_profile_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE demo_profiles ALTER COLUMN id SET DEFAULT nextval('demo_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE demo_user_groups ALTER COLUMN id SET DEFAULT nextval('demo_user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE discovery_ratings ALTER COLUMN id SET DEFAULT nextval('discovery_ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE dismissed_dialogs ALTER COLUMN id SET DEFAULT nextval('dismissed_dialogs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE eb_playlist_items ALTER COLUMN id SET DEFAULT nextval('eb_playlist_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE eb_playlists ALTER COLUMN id SET DEFAULT nextval('eb_playlists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ecommerce_inventory_item_optgroups ALTER COLUMN id SET DEFAULT nextval('ecommerce_inventory_item_optgroups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ecommerce_inventory_item_options ALTER COLUMN id SET DEFAULT nextval('ecommerce_inventory_item_options_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ecommerce_inventory_items ALTER COLUMN id SET DEFAULT nextval('ecommerce_inventory_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ecommerce_invoice_bill_addresses ALTER COLUMN id SET DEFAULT nextval('ecommerce_invoice_bill_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ecommerce_invoice_items ALTER COLUMN id SET DEFAULT nextval('ecommerce_invoice_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ecommerce_invoice_notes ALTER COLUMN id SET DEFAULT nextval('ecommerce_invoice_notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ecommerce_invoice_ship_addresses ALTER COLUMN id SET DEFAULT nextval('ecommerce_invoice_ship_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ecommerce_invoice_transactions ALTER COLUMN id SET DEFAULT nextval('ecommerce_invoice_transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ecommerce_invoices ALTER COLUMN id SET DEFAULT nextval('ecommerce_invoices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ecommerce_subscription_billing_modifiers ALTER COLUMN id SET DEFAULT nextval('ecommerce_subscription_billing_modifiers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ecommerce_subscription_payment_profiles ALTER COLUMN id SET DEFAULT nextval('ecommerce_subscription_payment_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ecommerce_subscriptions ALTER COLUMN id SET DEFAULT nextval('ecommerce_subscriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE editable_block_asset_views ALTER COLUMN id SET DEFAULT nextval('editable_block_asset_views_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE editable_block_assets ALTER COLUMN id SET DEFAULT nextval('editable_block_assets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE editable_blocks ALTER COLUMN id SET DEFAULT nextval('editable_blocks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE editorial_blocks ALTER COLUMN id SET DEFAULT nextval('editorial_blocks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE editorial_item_channels ALTER COLUMN id SET DEFAULT nextval('editorial_item_channels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ej_page_blocks ALTER COLUMN id SET DEFAULT nextval('ej_page_blocks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ej_rundown_thangs ALTER COLUMN id SET DEFAULT nextval('ej_rundown_thangs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ej_rundowns ALTER COLUMN id SET DEFAULT nextval('ej_rundowns_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ej_thangs ALTER COLUMN id SET DEFAULT nextval('ej_thangs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ej_title_images ALTER COLUMN id SET DEFAULT nextval('ej_title_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE email_campaign_results ALTER COLUMN id SET DEFAULT nextval('email_campaign_results_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE embedded_player_hits ALTER COLUMN id SET DEFAULT nextval('embedded_player_hits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE embedded_players ALTER COLUMN id SET DEFAULT nextval('embedded_players_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE entries ALTER COLUMN id SET DEFAULT nextval('entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE entry_groups ALTER COLUMN id SET DEFAULT nextval('entry_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE entry_rank_trackers ALTER COLUMN id SET DEFAULT nextval('entry_rank_trackers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE entry_selects ALTER COLUMN id SET DEFAULT nextval('entry_selects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE entry_views ALTER COLUMN id SET DEFAULT nextval('entry_views_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE envelopes ALTER COLUMN id SET DEFAULT nextval('envelopes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE epk_answers ALTER COLUMN id SET DEFAULT nextval('epk_answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE epk_available_answers ALTER COLUMN id SET DEFAULT nextval('epk_available_answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE epk_questions ALTER COLUMN id SET DEFAULT nextval('epk_questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE event_source_genres ALTER COLUMN id SET DEFAULT nextval('event_source_genres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE events_events ALTER COLUMN id SET DEFAULT nextval('events_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE events_externals ALTER COLUMN id SET DEFAULT nextval('events_externals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE events_genres ALTER COLUMN id SET DEFAULT nextval('events_genres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE events_performers ALTER COLUMN id SET DEFAULT nextval('events_performers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE events_presenters ALTER COLUMN id SET DEFAULT nextval('events_presenters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE events_rsvps ALTER COLUMN id SET DEFAULT nextval('events_rsvps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE events_venues ALTER COLUMN id SET DEFAULT nextval('events_venues_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE experiments ALTER COLUMN id SET DEFAULT nextval('experiments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE facebook_accounts ALTER COLUMN id SET DEFAULT nextval('facebook_accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE facebook_api_keys ALTER COLUMN id SET DEFAULT nextval('facebook_api_keys_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE facebook_templates ALTER COLUMN id SET DEFAULT nextval('facebook_templates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE fans ALTER COLUMN id SET DEFAULT nextval('new_fans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE faq_categories ALTER COLUMN id SET DEFAULT nextval('faq_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE faqs ALTER COLUMN id SET DEFAULT nextval('faqs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE favorite_channels ALTER COLUMN id SET DEFAULT nextval('favorite_channels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE favorite_entries ALTER COLUMN id SET DEFAULT nextval('favorite_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE feature_categories ALTER COLUMN id SET DEFAULT nextval('feature_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE feature_images ALTER COLUMN id SET DEFAULT nextval('feature_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE feature_items ALTER COLUMN id SET DEFAULT nextval('feature_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE feed_blurbs ALTER COLUMN id SET DEFAULT nextval('feed_blurbs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE feed_mills ALTER COLUMN id SET DEFAULT nextval('feed_mills_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE feed_refers ALTER COLUMN id SET DEFAULT nextval('feed_refers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE form_letters ALTER COLUMN id SET DEFAULT nextval('form_letters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE free_tracks ALTER COLUMN id SET DEFAULT nextval('free_tracks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE function_profiles ALTER COLUMN id SET DEFAULT nextval('function_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE games_talent_battles ALTER COLUMN id SET DEFAULT nextval('talent_battles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE games_talent_games ALTER COLUMN id SET DEFAULT nextval('talent_games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE games_talent_players ALTER COLUMN id SET DEFAULT nextval('games_talent_players_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE games_talent_ranks ALTER COLUMN id SET DEFAULT nextval('talent_ranks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE games_talent_rounds ALTER COLUMN id SET DEFAULT nextval('talent_rounds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE games_talent_scripts ALTER COLUMN id SET DEFAULT nextval('scripts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE genre_prefs ALTER COLUMN id SET DEFAULT nextval('genre_prefs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE geo_searches ALTER COLUMN id SET DEFAULT nextval('geo_searches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE giveaway_entries ALTER COLUMN id SET DEFAULT nextval('giveaway_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE giveaways ALTER COLUMN id SET DEFAULT nextval('giveaways_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE google_tokens ALTER COLUMN id SET DEFAULT nextval('google_tokens_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ignored_user_agents ALTER COLUMN id SET DEFAULT nextval('ignored_user_agents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE illegal_email_domains ALTER COLUMN id SET DEFAULT nextval('illegal_email_domains_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE invitations ALTER COLUMN id SET DEFAULT nextval('invitations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE item_lists ALTER COLUMN id SET DEFAULT nextval('item_lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jango_infos ALTER COLUMN id SET DEFAULT nextval('jango_infos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jury_games ALTER COLUMN id SET DEFAULT nextval('jury_games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jury_genres ALTER COLUMN id SET DEFAULT nextval('jury_genres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jury_ratings ALTER COLUMN id SET DEFAULT nextval('jury_ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jury_regions ALTER COLUMN id SET DEFAULT nextval('jury_regions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jury_trivia_answers ALTER COLUMN id SET DEFAULT nextval('jury_trivia_answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE jury_trivia_questions ALTER COLUMN id SET DEFAULT nextval('jury_trivia_questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE lazona_users ALTER COLUMN id SET DEFAULT nextval('lazona_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE letters ALTER COLUMN id SET DEFAULT nextval('letters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE license_agreements ALTER COLUMN id SET DEFAULT nextval('license_agreements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE licensing_request_actions ALTER COLUMN id SET DEFAULT nextval('licensing_request_actions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE licensing_requests ALTER COLUMN id SET DEFAULT nextval('licensing_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE limbo_battles ALTER COLUMN id SET DEFAULT nextval('limbo_battles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE listing_categories ALTER COLUMN id SET DEFAULT nextval('listing_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE listing_genres ALTER COLUMN id SET DEFAULT nextval('listing_genres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE listing_threads ALTER COLUMN id SET DEFAULT nextval('listing_threads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE listings ALTER COLUMN id SET DEFAULT nextval('listings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE live_chat_rooms ALTER COLUMN id SET DEFAULT nextval('live_chat_rooms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE live_feed_items ALTER COLUMN id SET DEFAULT nextval('live_feed_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE live_user_states ALTER COLUMN id SET DEFAULT nextval('live_user_states_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE locks ALTER COLUMN id SET DEFAULT nextval('locks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE market_place_epks ALTER COLUMN id SET DEFAULT nextval('market_place_epks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE market_place_presses ALTER COLUMN id SET DEFAULT nextval('market_place_presses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_applicant_payments ALTER COLUMN id SET DEFAULT nextval('marketplace_applicant_payments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_applicants ALTER COLUMN id SET DEFAULT nextval('marketplace_applicants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_artist_info_answers ALTER COLUMN id SET DEFAULT nextval('marketplace_artist_info_answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_artist_scores ALTER COLUMN id SET DEFAULT nextval('marketplace_artist_scores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_channel_scores ALTER COLUMN id SET DEFAULT nextval('marketplace_channel_scores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_contest_categories ALTER COLUMN id SET DEFAULT nextval('marketplace_contest_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_contest_items ALTER COLUMN id SET DEFAULT nextval('marketplace_contest_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_filters ALTER COLUMN id SET DEFAULT nextval('marketplace_filters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_gig_actions ALTER COLUMN id SET DEFAULT nextval('marketplace_gig_actions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_gig_agent_logs ALTER COLUMN id SET DEFAULT nextval('marketplace_gig_agent_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_gigs ALTER COLUMN id SET DEFAULT nextval('marketplace_gigs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_invites ALTER COLUMN id SET DEFAULT nextval('marketplace_invites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_qualification_overrides ALTER COLUMN id SET DEFAULT nextval('marketplace_qualification_overrides_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_venue_artist_categories ALTER COLUMN id SET DEFAULT nextval('marketplace_evaluations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_venue_artist_rating_comments ALTER COLUMN id SET DEFAULT nextval('marketplace_venue_artist_rating_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_venue_artist_ratings ALTER COLUMN id SET DEFAULT nextval('marketplace_venue_artist_ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_venue_artist_recommendations ALTER COLUMN id SET DEFAULT nextval('marketplace_venue_artist_recommendations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_venue_contacts ALTER COLUMN id SET DEFAULT nextval('marketplace_venue_contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE marketplace_venues ALTER COLUMN id SET DEFAULT nextval('marketplace_venues_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE media_assets_images ALTER COLUMN id SET DEFAULT nextval('media_assets_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE media_item_license_agreements ALTER COLUMN id SET DEFAULT nextval('media_item_license_agreements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE media_item_play_counts ALTER COLUMN id SET DEFAULT nextval('media_item_play_counts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE media_item_ratings ALTER COLUMN id SET DEFAULT nextval('media_item_ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE media_item_views ALTER COLUMN id SET DEFAULT nextval('media_item_views_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE media_items ALTER COLUMN id SET DEFAULT nextval('media_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE media_market_zipcodes ALTER COLUMN id SET DEFAULT nextval('media_market_zipcodes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE media_markets ALTER COLUMN id SET DEFAULT nextval('media_markets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE media_types ALTER COLUMN id SET DEFAULT nextval('genres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE message_blockers ALTER COLUMN id SET DEFAULT nextval('message_blockers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE message_templates ALTER COLUMN id SET DEFAULT nextval('message_templates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE messages_blasts ALTER COLUMN id SET DEFAULT nextval('messages_blasts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE messages_blastvelopes ALTER COLUMN id SET DEFAULT nextval('messages_blastvelopes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE messages_conversations ALTER COLUMN id SET DEFAULT nextval('messages_conversations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE messages_envelopes ALTER COLUMN id SET DEFAULT nextval('messages_envelopes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE messages_letters ALTER COLUMN id SET DEFAULT nextval('messages_letters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE microsite_bunchball_trophies ALTER COLUMN id SET DEFAULT nextval('microsite_bunchball_trophies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE microsite_domains ALTER COLUMN id SET DEFAULT nextval('microsite_domains_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE mojos_best_of_artists ALTER COLUMN id SET DEFAULT nextval('mojos_best_of_artists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE mojos_best_of_genre_artists ALTER COLUMN id SET DEFAULT nextval('mojos_best_of_genre_artists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE mojos_best_of_tracks ALTER COLUMN id SET DEFAULT nextval('mojos_best_of_tracks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE mojos_external_artist_data ALTER COLUMN id SET DEFAULT nextval('mojos_external_artist_data_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE network_companies ALTER COLUMN id SET DEFAULT nextval('network_companies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE network_company_labels ALTER COLUMN id SET DEFAULT nextval('network_company_labels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE network_essay_revisions ALTER COLUMN id SET DEFAULT nextval('network_essay_revisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE network_essays ALTER COLUMN id SET DEFAULT nextval('network_essays_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE network_galleries ALTER COLUMN id SET DEFAULT nextval('network_galleries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE network_gallery_items ALTER COLUMN id SET DEFAULT nextval('network_gallery_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE network_labels ALTER COLUMN id SET DEFAULT nextval('network_labels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE network_uris ALTER COLUMN id SET DEFAULT nextval('network_uris_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE new_banner_hits ALTER COLUMN id SET DEFAULT nextval('new_banner_hits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE nominees ALTER COLUMN id SET DEFAULT nextval('nominees_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE onliners ALTER COLUMN id SET DEFAULT nextval('onliners_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE our_locations ALTER COLUMN id SET DEFAULT nextval('our_locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ourcal_calendars ALTER COLUMN id SET DEFAULT nextval('ourcal_calendars_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ourcal_event_locations ALTER COLUMN id SET DEFAULT nextval('ourcal_event_locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ourcal_events ALTER COLUMN id SET DEFAULT nextval('ourcal_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE page_hits ALTER COLUMN id SET DEFAULT nextval('page_hits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE partners ALTER COLUMN id SET DEFAULT nextval('partners_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE phases ALTER COLUMN id SET DEFAULT nextval('phases_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE plaques ALTER COLUMN id SET DEFAULT nextval('plaques_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE playlists ALTER COLUMN id SET DEFAULT nextval('playlists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE playlists_items ALTER COLUMN id SET DEFAULT nextval('playlists_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE playlists_shared_supervision_playlists ALTER COLUMN id SET DEFAULT nextval('playlists_shared_supervision_playlists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE playlists_to_players ALTER COLUMN id SET DEFAULT nextval('playlists_to_players_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE playlists_user_playlists ALTER COLUMN id SET DEFAULT nextval('playlists_user_playlists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE points_item_offers ALTER COLUMN id SET DEFAULT nextval('points_item_offers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE points_item_purchases ALTER COLUMN id SET DEFAULT nextval('points_item_purchases_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE predictors ALTER COLUMN id SET DEFAULT nextval('predictors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE prize_winners ALTER COLUMN id SET DEFAULT nextval('prize_winners_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE profile_page_rollups ALTER COLUMN id SET DEFAULT nextval('profile_page_rollups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE promo_data_judge_clicks ALTER COLUMN id SET DEFAULT nextval('promo_data_judge_clicks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE promo_download_authorizations ALTER COLUMN id SET DEFAULT nextval('promo_download_authorizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE promotion_user_data ALTER COLUMN id SET DEFAULT nextval('promotion_user_data_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE promotion_user_data_fields ALTER COLUMN id SET DEFAULT nextval('promotion_user_data_fields_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE promotions ALTER COLUMN id SET DEFAULT nextval('promotions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE purchasable_codes ALTER COLUMN id SET DEFAULT nextval('purchasable_codes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE qaos_user_entry_scores ALTER COLUMN id SET DEFAULT nextval('qaos_user_entry_scores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE radio_settings ALTER COLUMN id SET DEFAULT nextval('radio_settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ranks ALTER COLUMN id SET DEFAULT nextval('ranks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE recommendations ALTER COLUMN id SET DEFAULT nextval('recommendations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE recommendations_parameter_groups ALTER COLUMN id SET DEFAULT nextval('recommendations_parameter_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE recommendations_parameters ALTER COLUMN id SET DEFAULT nextval('recommendations_parameters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE recommended_artists ALTER COLUMN id SET DEFAULT nextval('recommended_artists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE recommended_events ALTER COLUMN id SET DEFAULT nextval('recommended_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE recommended_songs ALTER COLUMN id SET DEFAULT nextval('recommended_songs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE regions ALTER COLUMN id SET DEFAULT nextval('regions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE remote_contests ALTER COLUMN id SET DEFAULT nextval('remote_contests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE requested_items ALTER COLUMN id SET DEFAULT nextval('requested_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE rev_share_defaults ALTER COLUMN id SET DEFAULT nextval('rev_share_defaults_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE rev_share_periods ALTER COLUMN id SET DEFAULT nextval('rev_share_periods_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE rev_share_records ALTER COLUMN id SET DEFAULT nextval('rev_share_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE rev_share_rollups ALTER COLUMN id SET DEFAULT nextval('rev_share_rollups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE rev_share_tier_sets ALTER COLUMN id SET DEFAULT nextval('rev_share_tier_sets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE rev_share_tiers ALTER COLUMN id SET DEFAULT nextval('rev_share_tiers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE role_groups ALTER COLUMN id SET DEFAULT nextval('role_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE scene_memberships ALTER COLUMN id SET DEFAULT nextval('scene_memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE scenes ALTER COLUMN id SET DEFAULT nextval('scenes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE schedules ALTER COLUMN id SET DEFAULT nextval('schedules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE score_factors ALTER COLUMN id SET DEFAULT nextval('score_factors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE search_locations ALTER COLUMN id SET DEFAULT nextval('search_locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE searched_strings ALTER COLUMN id SET DEFAULT nextval('searched_strings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE send_items ALTER COLUMN id SET DEFAULT nextval('send_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE site_actions ALTER COLUMN id SET DEFAULT nextval('site_actions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE site_visits ALTER COLUMN id SET DEFAULT nextval('site_visits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE sites ALTER COLUMN id SET DEFAULT nextval('sites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE sms_codes ALTER COLUMN id SET DEFAULT nextval('sms_codes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE sms_contests ALTER COLUMN id SET DEFAULT nextval('sms_contests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE sms_entries ALTER COLUMN id SET DEFAULT nextval('sms_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE stage_plot_elements ALTER COLUMN id SET DEFAULT nextval('stage_plot_elements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE stage_plots ALTER COLUMN id SET DEFAULT nextval('stage_plots_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE subscriptions_plans ALTER COLUMN id SET DEFAULT nextval('subscriptions_plans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE subscriptions_purchased_songs ALTER COLUMN id SET DEFAULT nextval('subscriptions_purchased_songs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE supervision_downloads ALTER COLUMN id SET DEFAULT nextval('supervision_downloads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE supervision_search_terms ALTER COLUMN id SET DEFAULT nextval('supervision_search_terms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE supervision_searches ALTER COLUMN id SET DEFAULT nextval('supervision_searches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE supervisor_media_item_reviews ALTER COLUMN id SET DEFAULT nextval('supervisor_media_item_reviews_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE tag_counts_old ALTER COLUMN id SET DEFAULT nextval('tag_counts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE tags_old ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE taste_space2_cluster_trees ALTER COLUMN id SET DEFAULT nextval('taste_space2_cluster_trees_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE taste_space2_clusters ALTER COLUMN id SET DEFAULT nextval('taste_space2_clusters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE taste_space2_disorders ALTER COLUMN id SET DEFAULT nextval('taste_space2_disorders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE taste_space2_points ALTER COLUMN id SET DEFAULT nextval('taste_space2_points_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE taste_space2_spaces ALTER COLUMN id SET DEFAULT nextval('taste_space2_spaces_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE taste_space_user_disorders ALTER COLUMN id SET DEFAULT nextval('taste_space_user_disorders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE thread_messages ALTER COLUMN id SET DEFAULT nextval('thread_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE translated_strings ALTER COLUMN id SET DEFAULT nextval('phase_keys_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE travis_artist_stats ALTER COLUMN id SET DEFAULT nextval('travis_artist_stats_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE travis_radio_format_channels ALTER COLUMN id SET DEFAULT nextval('travis_radio_format_channels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE travis_radio_formats ALTER COLUMN id SET DEFAULT nextval('travis_radio_formats_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE travis_track_stats ALTER COLUMN id SET DEFAULT nextval('travis_track_stats_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE user_fb_event_pending_scrapes ALTER COLUMN id SET DEFAULT nextval('user_fb_event_pending_scrapes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE user_groups ALTER COLUMN id SET DEFAULT nextval('user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE user_infos ALTER COLUMN id SET DEFAULT nextval('user_infos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE user_regions ALTER COLUMN id SET DEFAULT nextval('user_regions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE user_roles ALTER COLUMN id SET DEFAULT nextval('user_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE user_tags_old ALTER COLUMN id SET DEFAULT nextval('user_tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_about_mes ALTER COLUMN id SET DEFAULT nextval('users_block_data_about_mes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_achievement_lists ALTER COLUMN id SET DEFAULT nextval('users_block_data_achievement_lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_artist_feeds ALTER COLUMN id SET DEFAULT nextval('users_block_data_artist_feeds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_blogs ALTER COLUMN id SET DEFAULT nextval('users_block_data_blogs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_comment_lists ALTER COLUMN id SET DEFAULT nextval('users_block_data_comment_lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_event_calendars ALTER COLUMN id SET DEFAULT nextval('users_block_data_event_calendars_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_fan_lists ALTER COLUMN id SET DEFAULT nextval('users_block_data_fan_lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_fc_memberships ALTER COLUMN id SET DEFAULT nextval('users_block_data_fc_memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_firsts ALTER COLUMN id SET DEFAULT nextval('users_block_data_firsts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_free_tracks ALTER COLUMN id SET DEFAULT nextval('users_block_data_free_tracks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_friend_feeds ALTER COLUMN id SET DEFAULT nextval('users_block_data_friend_feeds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_friend_lists ALTER COLUMN id SET DEFAULT nextval('users_block_data_friend_lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_influences ALTER COLUMN id SET DEFAULT nextval('users_block_data_influences_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_judge_histories ALTER COLUMN id SET DEFAULT nextval('users_block_data_judge_histories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_link_boxes ALTER COLUMN id SET DEFAULT nextval('users_block_data_link_boxes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_live_feeds ALTER COLUMN id SET DEFAULT nextval('users_block_data_live_feeds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_media_item_lists ALTER COLUMN id SET DEFAULT nextval('users_block_data_media_item_lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_music_favorites ALTER COLUMN id SET DEFAULT nextval('users_block_data_music_favorites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_music_maps ALTER COLUMN id SET DEFAULT nextval('users_block_data_music_maps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_music_players ALTER COLUMN id SET DEFAULT nextval('users_block_data_music_players_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_my_accounts ALTER COLUMN id SET DEFAULT nextval('users_block_data_my_accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_photo_galleries ALTER COLUMN id SET DEFAULT nextval('users_block_data_photo_galleries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_stage_specs ALTER COLUMN id SET DEFAULT nextval('users_block_data_stage_specs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_venue_infos ALTER COLUMN id SET DEFAULT nextval('users_block_data_venue_infos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_video_favorites ALTER COLUMN id SET DEFAULT nextval('users_block_data_video_favorites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_block_data_video_players ALTER COLUMN id SET DEFAULT nextval('users_block_data_video_players_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_deferred_earnings ALTER COLUMN id SET DEFAULT nextval('users_deferred_earnings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_demographics ALTER COLUMN id SET DEFAULT nextval('users_demographics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_donations ALTER COLUMN id SET DEFAULT nextval('users_donations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_external_uris ALTER COLUMN id SET DEFAULT nextval('users_external_uris_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_finance_rollups ALTER COLUMN id SET DEFAULT nextval('users_finance_rollups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_finances ALTER COLUMN id SET DEFAULT nextval('users_finances_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_friendships ALTER COLUMN id SET DEFAULT nextval('users_friendships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_photo_galleries ALTER COLUMN id SET DEFAULT nextval('users_photo_galleries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_photo_gallery_items ALTER COLUMN id SET DEFAULT nextval('users_photo_gallery_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_profile_blocks ALTER COLUMN id SET DEFAULT nextval('users_profile_blocks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_profile_links ALTER COLUMN id SET DEFAULT nextval('users_profile_links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_profile_pages ALTER COLUMN id SET DEFAULT nextval('users_profile_pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_profiles ALTER COLUMN id SET DEFAULT nextval('users_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE users_user_uris ALTER COLUMN id SET DEFAULT nextval('users_user_uris_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE util_our_stats ALTER COLUMN id SET DEFAULT nextval('util_our_stats_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE util_parameters ALTER COLUMN id SET DEFAULT nextval('util_parameters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE vote_records ALTER COLUMN id SET DEFAULT nextval('vote_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE welcome_page_emails ALTER COLUMN id SET DEFAULT nextval('welcome_page_emails_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE widget_giveaways ALTER COLUMN id SET DEFAULT nextval('widget_giveaways_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE widget_sessions ALTER COLUMN id SET DEFAULT nextval('widget_sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE widgets ALTER COLUMN id SET DEFAULT nextval('widgets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE word_press_authors ALTER COLUMN id SET DEFAULT nextval('word_press_authors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE word_press_categories ALTER COLUMN id SET DEFAULT nextval('word_press_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE word_press_posts ALTER COLUMN id SET DEFAULT nextval('word_press_posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE word_press_tags ALTER COLUMN id SET DEFAULT nextval('word_press_tags_id_seq'::regclass);


--
-- Name: account_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY account_actions
    ADD CONSTRAINT account_actions_pkey PRIMARY KEY (id);


--
-- Name: achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- Name: activation_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activation_requests
    ADD CONSTRAINT activation_requests_pkey PRIMARY KEY (id);


--
-- Name: admin_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT admin_notes_pkey PRIMARY KEY (id);


--
-- Name: administration_ignore_object_matches_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY administration_ignore_object_matches
    ADD CONSTRAINT administration_ignore_object_matches_pkey PRIMARY KEY (id);


--
-- Name: ads_ads_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ads_ads
    ADD CONSTRAINT ads_ads_pkey PRIMARY KEY (id);


--
-- Name: ads_channel_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ads_channel_groups
    ADD CONSTRAINT ads_channel_groups_pkey PRIMARY KEY (id);


--
-- Name: anonymous_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY anonymous_ratings
    ADD CONSTRAINT anonymous_ratings_pkey PRIMARY KEY (id);


--
-- Name: anonymous_user_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY anonymous_user_records
    ADD CONSTRAINT anonymous_user_records_pkey PRIMARY KEY (id);


--
-- Name: app_stuffs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY app_stuffs
    ADD CONSTRAINT app_stuffs_pkey PRIMARY KEY (id);


--
-- Name: artist_accesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY artist_accesses
    ADD CONSTRAINT artist_accesses_pkey PRIMARY KEY (id);


--
-- Name: artist_referrals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY artist_referrals
    ADD CONSTRAINT artist_referrals_pkey PRIMARY KEY (id);


--
-- Name: authnet_cim_payment_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY authnet_cim_payment_profiles
    ADD CONSTRAINT authnet_cim_payment_profiles_pkey PRIMARY KEY (id);


--
-- Name: authnet_cim_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY authnet_cim_profiles
    ADD CONSTRAINT authnet_cim_profiles_pkey PRIMARY KEY (id);


--
-- Name: authnet_cim_shipping_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY authnet_cim_shipping_profiles
    ADD CONSTRAINT authnet_cim_shipping_profiles_pkey PRIMARY KEY (id);


--
-- Name: authorizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY authorizations
    ADD CONSTRAINT authorizations_pkey PRIMARY KEY (id);


--
-- Name: background_task_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY background_task_logs
    ADD CONSTRAINT background_task_logs_pkey PRIMARY KEY (id);

ALTER TABLE background_task_logs CLUSTER ON background_task_logs_pkey;


--
-- Name: background_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY background_tasks
    ADD CONSTRAINT background_tasks_pkey PRIMARY KEY (id);

ALTER TABLE background_tasks CLUSTER ON background_tasks_pkey;


--
-- Name: bad_ip_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bad_ip_addresses
    ADD CONSTRAINT bad_ip_addresses_pkey PRIMARY KEY (id);


--
-- Name: bands_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bands
    ADD CONSTRAINT bands_pkey PRIMARY KEY (id);


--
-- Name: banner_hits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY banner_hits
    ADD CONSTRAINT banner_hits_pkey PRIMARY KEY (id);


--
-- Name: banner_themes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY banner_themes
    ADD CONSTRAINT banner_themes_pkey PRIMARY KEY (id);


--
-- Name: battle_behavior_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY battle_behavior_ratings
    ADD CONSTRAINT battle_behavior_ratings_pkey PRIMARY KEY (id);

ALTER TABLE battle_behavior_ratings CLUSTER ON battle_behavior_ratings_pkey;


--
-- Name: battle_influences_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY battle_influences
    ADD CONSTRAINT battle_influences_pkey PRIMARY KEY (id);


--
-- Name: battles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY battles
    ADD CONSTRAINT battles_pkey PRIMARY KEY (id);


--
-- Name: beta_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY beta_invitations
    ADD CONSTRAINT beta_invitations_pkey PRIMARY KEY (id);


--
-- Name: blacklists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY blacklists
    ADD CONSTRAINT blacklists_pkey PRIMARY KEY (id);


--
-- Name: build_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY build_statuses
    ADD CONSTRAINT build_statuses_pkey PRIMARY KEY (id);


--
-- Name: bunchball_trophies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bunchball_trophies
    ADD CONSTRAINT bunchball_trophies_pkey PRIMARY KEY (id);


--
-- Name: bunchball_trophy_grants_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bunchball_trophy_grants
    ADD CONSTRAINT bunchball_trophy_grants_pkey PRIMARY KEY (id);


--
-- Name: canonical_artist_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY canonical_artist_names
    ADD CONSTRAINT canonical_artist_names_pkey PRIMARY KEY (id);


--
-- Name: captchas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY captchas
    ADD CONSTRAINT captchas_pkey PRIMARY KEY (id);


--
-- Name: cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- Name: carts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: catalog_item_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY catalog_item_photos
    ADD CONSTRAINT catalog_item_photos_pkey PRIMARY KEY (id);


--
-- Name: catalog_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY catalog_items
    ADD CONSTRAINT catalog_items_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: channel_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY channel_genres
    ADD CONSTRAINT channel_genres_pkey PRIMARY KEY (id);


--
-- Name: channel_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY channel_groups
    ADD CONSTRAINT channel_groups_pkey PRIMARY KEY (id);


--
-- Name: channel_views_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY channel_views
    ADD CONSTRAINT channel_views_pkey PRIMARY KEY (id);


--
-- Name: channels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (id);


--
-- Name: chart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY chart_items
    ADD CONSTRAINT chart_items_pkey PRIMARY KEY (id);


--
-- Name: charts_best_of_best_approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY charts_best_of_best_approvals
    ADD CONSTRAINT charts_best_of_best_approvals_pkey PRIMARY KEY (id);


--
-- Name: charts_best_of_best_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY charts_best_of_best_genres
    ADD CONSTRAINT charts_best_of_best_genres_pkey PRIMARY KEY (id);


--
-- Name: charts_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY charts_categories
    ADD CONSTRAINT charts_categories_pkey PRIMARY KEY (id);


--
-- Name: charts_charts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY charts_charts
    ADD CONSTRAINT charts_charts_pkey PRIMARY KEY (id);


--
-- Name: charts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY charts
    ADD CONSTRAINT charts_pkey PRIMARY KEY (id);


--
-- Name: charts_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY charts_positions
    ADD CONSTRAINT charts_positions_pkey PRIMARY KEY (id);


--
-- Name: chats_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY chats
    ADD CONSTRAINT chats_pkey PRIMARY KEY (id);


--
-- Name: checksums_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY checksums
    ADD CONSTRAINT checksums_pkey PRIMARY KEY (id);


--
-- Name: classify_competition_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY classify_competition_genres
    ADD CONSTRAINT classify_competition_genres_pkey PRIMARY KEY (id);


--
-- Name: classify_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY classify_genres
    ADD CONSTRAINT classify_genres_pkey PRIMARY KEY (id);


--
-- Name: classify_media_item_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY classify_media_item_genres
    ADD CONSTRAINT classify_media_item_genres_pkey PRIMARY KEY (id);


--
-- Name: co_brandings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY co_brandings
    ADD CONSTRAINT co_brandings_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: compete_competitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY compete_competitions
    ADD CONSTRAINT compete_competitions_pkey PRIMARY KEY (id);


--
-- Name: compete_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY compete_entries
    ADD CONSTRAINT compete_entries_pkey PRIMARY KEY (id);


--
-- Name: complaints_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY complaints
    ADD CONSTRAINT complaints_pkey PRIMARY KEY (id);


--
-- Name: completes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY completes
    ADD CONSTRAINT completes_pkey PRIMARY KEY (id);


--
-- Name: contest_credit_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contest_credit_transactions
    ADD CONSTRAINT contest_credit_transactions_pkey PRIMARY KEY (id);


--
-- Name: contest_credits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contest_credits
    ADD CONSTRAINT contest_credits_pkey PRIMARY KEY (id);


--
-- Name: contest_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contest_templates
    ADD CONSTRAINT contest_templates_pkey PRIMARY KEY (id);


--
-- Name: contests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contests
    ADD CONSTRAINT contests_pkey PRIMARY KEY (id);


--
-- Name: custom_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY custom_registrations
    ADD CONSTRAINT custom_registrations_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: demo_battles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY demo_battles
    ADD CONSTRAINT demo_battles_pkey PRIMARY KEY (id);


--
-- Name: demo_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY demo_categories
    ADD CONSTRAINT demo_categories_pkey PRIMARY KEY (id);


--
-- Name: demo_entry_statistics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY demo_entry_statistics
    ADD CONSTRAINT demo_entry_statistics_pkey PRIMARY KEY (id);


--
-- Name: demo_group_partitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY demo_group_partitions
    ADD CONSTRAINT demo_group_partitions_pkey PRIMARY KEY (id);


--
-- Name: demo_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY demo_groups
    ADD CONSTRAINT demo_groups_pkey PRIMARY KEY (id);


--
-- Name: demo_partitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY demo_partitions
    ADD CONSTRAINT demo_partitions_pkey PRIMARY KEY (id);


--
-- Name: demo_profile_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY demo_profile_groups
    ADD CONSTRAINT demo_profile_groups_pkey PRIMARY KEY (id);


--
-- Name: demo_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY demo_profiles
    ADD CONSTRAINT demo_profiles_pkey PRIMARY KEY (id);


--
-- Name: demo_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY demo_user_groups
    ADD CONSTRAINT demo_user_groups_pkey PRIMARY KEY (id);


--
-- Name: discovery_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY discovery_ratings
    ADD CONSTRAINT discovery_ratings_pkey PRIMARY KEY (id);


--
-- Name: dismissed_dialogs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dismissed_dialogs
    ADD CONSTRAINT dismissed_dialogs_pkey PRIMARY KEY (id);


--
-- Name: eb_playlist_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY eb_playlist_items
    ADD CONSTRAINT eb_playlist_items_pkey PRIMARY KEY (id);


--
-- Name: eb_playlists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY eb_playlists
    ADD CONSTRAINT eb_playlists_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_inventory_item_optgroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ecommerce_inventory_item_optgroups
    ADD CONSTRAINT ecommerce_inventory_item_optgroups_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_inventory_item_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ecommerce_inventory_item_options
    ADD CONSTRAINT ecommerce_inventory_item_options_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ecommerce_inventory_items
    ADD CONSTRAINT ecommerce_inventory_items_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_invoice_bill_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ecommerce_invoice_bill_addresses
    ADD CONSTRAINT ecommerce_invoice_bill_addresses_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_invoice_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ecommerce_invoice_items
    ADD CONSTRAINT ecommerce_invoice_items_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_invoice_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ecommerce_invoice_notes
    ADD CONSTRAINT ecommerce_invoice_notes_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_invoice_ship_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ecommerce_invoice_ship_addresses
    ADD CONSTRAINT ecommerce_invoice_ship_addresses_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_invoice_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ecommerce_invoice_transactions
    ADD CONSTRAINT ecommerce_invoice_transactions_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ecommerce_invoices
    ADD CONSTRAINT ecommerce_invoices_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_subscription_billing_modifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ecommerce_subscription_billing_modifiers
    ADD CONSTRAINT ecommerce_subscription_billing_modifiers_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_subscription_payment_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ecommerce_subscription_payment_profiles
    ADD CONSTRAINT ecommerce_subscription_payment_profiles_pkey PRIMARY KEY (id);


--
-- Name: ecommerce_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ecommerce_subscriptions
    ADD CONSTRAINT ecommerce_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: editable_block_asset_views_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY editable_block_asset_views
    ADD CONSTRAINT editable_block_asset_views_pkey PRIMARY KEY (id);


--
-- Name: editable_block_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY editable_block_assets
    ADD CONSTRAINT editable_block_assets_pkey PRIMARY KEY (id);


--
-- Name: editable_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY editable_blocks
    ADD CONSTRAINT editable_blocks_pkey PRIMARY KEY (id);


--
-- Name: editorial_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY editorial_blocks
    ADD CONSTRAINT editorial_blocks_pkey PRIMARY KEY (id);


--
-- Name: editorial_item_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY editorial_item_channels
    ADD CONSTRAINT editorial_item_channels_pkey PRIMARY KEY (id);


--
-- Name: ej_page_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ej_page_blocks
    ADD CONSTRAINT ej_page_blocks_pkey PRIMARY KEY (id);


--
-- Name: ej_rundown_thangs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ej_rundown_thangs
    ADD CONSTRAINT ej_rundown_thangs_pkey PRIMARY KEY (id);


--
-- Name: ej_rundowns_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ej_rundowns
    ADD CONSTRAINT ej_rundowns_pkey PRIMARY KEY (id);


--
-- Name: ej_thangs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ej_thangs
    ADD CONSTRAINT ej_thangs_pkey PRIMARY KEY (id);


--
-- Name: ej_title_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ej_title_images
    ADD CONSTRAINT ej_title_images_pkey PRIMARY KEY (id);


--
-- Name: email_campaign_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY email_campaign_results
    ADD CONSTRAINT email_campaign_results_pkey PRIMARY KEY (id);


--
-- Name: embedded_player_hits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY embedded_player_hits
    ADD CONSTRAINT embedded_player_hits_pkey PRIMARY KEY (id);


--
-- Name: embedded_players_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY embedded_players
    ADD CONSTRAINT embedded_players_pkey PRIMARY KEY (id);


--
-- Name: entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY entries
    ADD CONSTRAINT entries_pkey PRIMARY KEY (id);


--
-- Name: entry_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY entry_groups
    ADD CONSTRAINT entry_groups_pkey PRIMARY KEY (id);


--
-- Name: entry_rank_trackers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY entry_rank_trackers
    ADD CONSTRAINT entry_rank_trackers_pkey PRIMARY KEY (id);


--
-- Name: entry_selects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY entry_selects
    ADD CONSTRAINT entry_selects_pkey PRIMARY KEY (id);


--
-- Name: entry_views_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY entry_views
    ADD CONSTRAINT entry_views_pkey PRIMARY KEY (id);


--
-- Name: envelopes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY envelopes
    ADD CONSTRAINT envelopes_pkey PRIMARY KEY (id);


--
-- Name: epk_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY epk_answers
    ADD CONSTRAINT epk_answers_pkey PRIMARY KEY (id);


--
-- Name: epk_available_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY epk_available_answers
    ADD CONSTRAINT epk_available_answers_pkey PRIMARY KEY (id);


--
-- Name: epk_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY epk_questions
    ADD CONSTRAINT epk_questions_pkey PRIMARY KEY (id);


--
-- Name: event_source_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_source_genres
    ADD CONSTRAINT event_source_genres_pkey PRIMARY KEY (id);


--
-- Name: events_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events_events
    ADD CONSTRAINT events_events_pkey PRIMARY KEY (id);


--
-- Name: events_externals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events_externals
    ADD CONSTRAINT events_externals_pkey PRIMARY KEY (id);


--
-- Name: events_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events_genres
    ADD CONSTRAINT events_genres_pkey PRIMARY KEY (id);


--
-- Name: events_performers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events_performers
    ADD CONSTRAINT events_performers_pkey PRIMARY KEY (id);


--
-- Name: events_presenters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events_presenters
    ADD CONSTRAINT events_presenters_pkey PRIMARY KEY (id);


--
-- Name: events_rsvps_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events_rsvps
    ADD CONSTRAINT events_rsvps_pkey PRIMARY KEY (id);


--
-- Name: events_venues_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events_venues
    ADD CONSTRAINT events_venues_pkey PRIMARY KEY (id);


--
-- Name: experiments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY experiments
    ADD CONSTRAINT experiments_pkey PRIMARY KEY (id);


--
-- Name: facebook_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY facebook_accounts
    ADD CONSTRAINT facebook_accounts_pkey PRIMARY KEY (id);


--
-- Name: facebook_api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY facebook_api_keys
    ADD CONSTRAINT facebook_api_keys_pkey PRIMARY KEY (id);


--
-- Name: facebook_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY facebook_templates
    ADD CONSTRAINT facebook_templates_pkey PRIMARY KEY (id);


--
-- Name: faq_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY faq_categories
    ADD CONSTRAINT faq_categories_pkey PRIMARY KEY (id);


--
-- Name: faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY faqs
    ADD CONSTRAINT faqs_pkey PRIMARY KEY (id);


--
-- Name: favorite_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY favorite_channels
    ADD CONSTRAINT favorite_channels_pkey PRIMARY KEY (id);


--
-- Name: favorite_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY favorite_entries
    ADD CONSTRAINT favorite_entries_pkey PRIMARY KEY (id);


--
-- Name: feature_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY feature_categories
    ADD CONSTRAINT feature_categories_pkey PRIMARY KEY (id);


--
-- Name: feature_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY feature_images
    ADD CONSTRAINT feature_images_pkey PRIMARY KEY (id);


--
-- Name: feature_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY feature_items
    ADD CONSTRAINT feature_items_pkey PRIMARY KEY (id);


--
-- Name: feed_blurbs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY feed_blurbs
    ADD CONSTRAINT feed_blurbs_pkey PRIMARY KEY (id);


--
-- Name: feed_mills_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY feed_mills
    ADD CONSTRAINT feed_mills_pkey PRIMARY KEY (id);


--
-- Name: feed_refers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY feed_refers
    ADD CONSTRAINT feed_refers_pkey PRIMARY KEY (id);


--
-- Name: form_letters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY form_letters
    ADD CONSTRAINT form_letters_pkey PRIMARY KEY (id);


--
-- Name: free_tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY free_tracks
    ADD CONSTRAINT free_tracks_pkey PRIMARY KEY (id);


--
-- Name: function_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY function_profiles
    ADD CONSTRAINT function_profiles_pkey PRIMARY KEY (id);


--
-- Name: games_talent_players_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY games_talent_players
    ADD CONSTRAINT games_talent_players_pkey PRIMARY KEY (id);


--
-- Name: genre_prefs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY genre_prefs
    ADD CONSTRAINT genre_prefs_pkey PRIMARY KEY (id);


--
-- Name: genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_types
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);


--
-- Name: geo_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY geo_searches
    ADD CONSTRAINT geo_searches_pkey PRIMARY KEY (id);


--
-- Name: giveaway_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY giveaway_entries
    ADD CONSTRAINT giveaway_entries_pkey PRIMARY KEY (id);


--
-- Name: giveaways_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY giveaways
    ADD CONSTRAINT giveaways_pkey PRIMARY KEY (id);


--
-- Name: google_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY google_tokens
    ADD CONSTRAINT google_tokens_pkey PRIMARY KEY (id);


--
-- Name: ignored_user_agents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ignored_user_agents
    ADD CONSTRAINT ignored_user_agents_pkey PRIMARY KEY (id);


--
-- Name: illegal_email_domains_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY illegal_email_domains
    ADD CONSTRAINT illegal_email_domains_pkey PRIMARY KEY (id);


--
-- Name: invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- Name: item_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY item_lists
    ADD CONSTRAINT item_lists_pkey PRIMARY KEY (id);


--
-- Name: jango_infos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jango_infos
    ADD CONSTRAINT jango_infos_pkey PRIMARY KEY (id);


--
-- Name: jury_games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jury_games
    ADD CONSTRAINT jury_games_pkey PRIMARY KEY (id);


--
-- Name: jury_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jury_genres
    ADD CONSTRAINT jury_genres_pkey PRIMARY KEY (id);


--
-- Name: jury_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jury_ratings
    ADD CONSTRAINT jury_ratings_pkey PRIMARY KEY (id);


--
-- Name: jury_regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jury_regions
    ADD CONSTRAINT jury_regions_pkey PRIMARY KEY (id);


--
-- Name: jury_trivia_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jury_trivia_answers
    ADD CONSTRAINT jury_trivia_answers_pkey PRIMARY KEY (id);


--
-- Name: jury_trivia_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jury_trivia_questions
    ADD CONSTRAINT jury_trivia_questions_pkey PRIMARY KEY (id);


--
-- Name: lazona_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lazona_users
    ADD CONSTRAINT lazona_users_pkey PRIMARY KEY (id);


--
-- Name: letters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY letters
    ADD CONSTRAINT letters_pkey PRIMARY KEY (id);


--
-- Name: license_agreements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY license_agreements
    ADD CONSTRAINT license_agreements_pkey PRIMARY KEY (id);


--
-- Name: licensing_request_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY licensing_request_actions
    ADD CONSTRAINT licensing_request_actions_pkey PRIMARY KEY (id);


--
-- Name: licensing_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY licensing_requests
    ADD CONSTRAINT licensing_requests_pkey PRIMARY KEY (id);


--
-- Name: limbo_battles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY limbo_battles
    ADD CONSTRAINT limbo_battles_pkey PRIMARY KEY (id);


--
-- Name: listing_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY listing_categories
    ADD CONSTRAINT listing_categories_pkey PRIMARY KEY (id);


--
-- Name: listing_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY listing_genres
    ADD CONSTRAINT listing_genres_pkey PRIMARY KEY (id);


--
-- Name: listing_threads_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY listing_threads
    ADD CONSTRAINT listing_threads_pkey PRIMARY KEY (id);


--
-- Name: listings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY listings
    ADD CONSTRAINT listings_pkey PRIMARY KEY (id);


--
-- Name: live_chat_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY live_chat_rooms
    ADD CONSTRAINT live_chat_rooms_pkey PRIMARY KEY (id);


--
-- Name: live_feed_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY live_feed_items
    ADD CONSTRAINT live_feed_items_pkey PRIMARY KEY (id);


--
-- Name: live_user_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY live_user_states
    ADD CONSTRAINT live_user_states_pkey PRIMARY KEY (id);


--
-- Name: locks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locks
    ADD CONSTRAINT locks_pkey PRIMARY KEY (id);

ALTER TABLE locks CLUSTER ON locks_pkey;


--
-- Name: market_place_epks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY market_place_epks
    ADD CONSTRAINT market_place_epks_pkey PRIMARY KEY (id);


--
-- Name: market_place_presses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY market_place_presses
    ADD CONSTRAINT market_place_presses_pkey PRIMARY KEY (id);


--
-- Name: marketplace_applicant_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_applicant_payments
    ADD CONSTRAINT marketplace_applicant_payments_pkey PRIMARY KEY (id);


--
-- Name: marketplace_applicants_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_applicants
    ADD CONSTRAINT marketplace_applicants_pkey PRIMARY KEY (id);


--
-- Name: marketplace_artist_info_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_artist_info_answers
    ADD CONSTRAINT marketplace_artist_info_answers_pkey PRIMARY KEY (id);


--
-- Name: marketplace_artist_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_artist_scores
    ADD CONSTRAINT marketplace_artist_scores_pkey PRIMARY KEY (id);


--
-- Name: marketplace_channel_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_channel_scores
    ADD CONSTRAINT marketplace_channel_scores_pkey PRIMARY KEY (id);


--
-- Name: marketplace_contest_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_contest_categories
    ADD CONSTRAINT marketplace_contest_categories_pkey PRIMARY KEY (id);


--
-- Name: marketplace_contest_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_contest_items
    ADD CONSTRAINT marketplace_contest_items_pkey PRIMARY KEY (id);


--
-- Name: marketplace_evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_venue_artist_categories
    ADD CONSTRAINT marketplace_evaluations_pkey PRIMARY KEY (id);


--
-- Name: marketplace_filters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_filters
    ADD CONSTRAINT marketplace_filters_pkey PRIMARY KEY (id);


--
-- Name: marketplace_gig_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_gig_actions
    ADD CONSTRAINT marketplace_gig_actions_pkey PRIMARY KEY (id);


--
-- Name: marketplace_gig_agent_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_gig_agent_logs
    ADD CONSTRAINT marketplace_gig_agent_logs_pkey PRIMARY KEY (id);


--
-- Name: marketplace_gigs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_gigs
    ADD CONSTRAINT marketplace_gigs_pkey PRIMARY KEY (id);


--
-- Name: marketplace_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_invites
    ADD CONSTRAINT marketplace_invites_pkey PRIMARY KEY (id);


--
-- Name: marketplace_qualification_overrides_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_qualification_overrides
    ADD CONSTRAINT marketplace_qualification_overrides_pkey PRIMARY KEY (id);


--
-- Name: marketplace_venue_artist_rating_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_venue_artist_rating_comments
    ADD CONSTRAINT marketplace_venue_artist_rating_comments_pkey PRIMARY KEY (id);


--
-- Name: marketplace_venue_artist_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_venue_artist_ratings
    ADD CONSTRAINT marketplace_venue_artist_ratings_pkey PRIMARY KEY (id);


--
-- Name: marketplace_venue_artist_recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_venue_artist_recommendations
    ADD CONSTRAINT marketplace_venue_artist_recommendations_pkey PRIMARY KEY (id);


--
-- Name: marketplace_venue_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_venue_contacts
    ADD CONSTRAINT marketplace_venue_contacts_pkey PRIMARY KEY (id);


--
-- Name: marketplace_venues_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY marketplace_venues
    ADD CONSTRAINT marketplace_venues_pkey PRIMARY KEY (id);


--
-- Name: media_assets_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_assets_images
    ADD CONSTRAINT media_assets_images_pkey PRIMARY KEY (id);


--
-- Name: media_item_license_agreements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_item_license_agreements
    ADD CONSTRAINT media_item_license_agreements_pkey PRIMARY KEY (id);


--
-- Name: media_item_play_counts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_item_play_counts
    ADD CONSTRAINT media_item_play_counts_pkey PRIMARY KEY (id);


--
-- Name: media_item_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_item_ratings
    ADD CONSTRAINT media_item_ratings_pkey PRIMARY KEY (id);


--
-- Name: media_item_views_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_item_views
    ADD CONSTRAINT media_item_views_pkey PRIMARY KEY (id);


--
-- Name: media_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_items
    ADD CONSTRAINT media_items_pkey PRIMARY KEY (id);


--
-- Name: media_market_zipcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_market_zipcodes
    ADD CONSTRAINT media_market_zipcodes_pkey PRIMARY KEY (id);


--
-- Name: media_markets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_markets
    ADD CONSTRAINT media_markets_pkey PRIMARY KEY (id);


--
-- Name: message_blockers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY message_blockers
    ADD CONSTRAINT message_blockers_pkey PRIMARY KEY (id);


--
-- Name: message_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY message_templates
    ADD CONSTRAINT message_templates_pkey PRIMARY KEY (id);


--
-- Name: messages_blasts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY messages_blasts
    ADD CONSTRAINT messages_blasts_pkey PRIMARY KEY (id);


--
-- Name: messages_blastvelopes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY messages_blastvelopes
    ADD CONSTRAINT messages_blastvelopes_pkey PRIMARY KEY (id);


--
-- Name: messages_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY messages_conversations
    ADD CONSTRAINT messages_conversations_pkey PRIMARY KEY (id);


--
-- Name: messages_envelopes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY messages_envelopes
    ADD CONSTRAINT messages_envelopes_pkey PRIMARY KEY (id);


--
-- Name: messages_letters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY messages_letters
    ADD CONSTRAINT messages_letters_pkey PRIMARY KEY (id);


--
-- Name: microsite_bunchball_trophies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY microsite_bunchball_trophies
    ADD CONSTRAINT microsite_bunchball_trophies_pkey PRIMARY KEY (id);


--
-- Name: microsite_domains_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY microsite_domains
    ADD CONSTRAINT microsite_domains_pkey PRIMARY KEY (id);


--
-- Name: mojos_best_of_artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mojos_best_of_artists
    ADD CONSTRAINT mojos_best_of_artists_pkey PRIMARY KEY (id);


--
-- Name: mojos_best_of_genre_artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mojos_best_of_genre_artists
    ADD CONSTRAINT mojos_best_of_genre_artists_pkey PRIMARY KEY (id);


--
-- Name: mojos_best_of_tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mojos_best_of_tracks
    ADD CONSTRAINT mojos_best_of_tracks_pkey PRIMARY KEY (id);


--
-- Name: mojos_external_artist_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mojos_external_artist_data
    ADD CONSTRAINT mojos_external_artist_data_pkey PRIMARY KEY (id);


--
-- Name: network_companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY network_companies
    ADD CONSTRAINT network_companies_pkey PRIMARY KEY (id);


--
-- Name: network_company_labels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY network_company_labels
    ADD CONSTRAINT network_company_labels_pkey PRIMARY KEY (id);


--
-- Name: network_essay_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY network_essay_revisions
    ADD CONSTRAINT network_essay_revisions_pkey PRIMARY KEY (id);


--
-- Name: network_essays_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY network_essays
    ADD CONSTRAINT network_essays_pkey PRIMARY KEY (id);


--
-- Name: network_galleries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY network_galleries
    ADD CONSTRAINT network_galleries_pkey PRIMARY KEY (id);


--
-- Name: network_gallery_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY network_gallery_items
    ADD CONSTRAINT network_gallery_items_pkey PRIMARY KEY (id);


--
-- Name: network_labels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY network_labels
    ADD CONSTRAINT network_labels_pkey PRIMARY KEY (id);


--
-- Name: network_uris_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY network_uris
    ADD CONSTRAINT network_uris_pkey PRIMARY KEY (id);


--
-- Name: new_banner_hits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY new_banner_hits
    ADD CONSTRAINT new_banner_hits_pkey PRIMARY KEY (id);


--
-- Name: new_fans_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fans
    ADD CONSTRAINT new_fans_pkey PRIMARY KEY (id);


--
-- Name: nominees_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY nominees
    ADD CONSTRAINT nominees_pkey PRIMARY KEY (id);


--
-- Name: onliners_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY onliners
    ADD CONSTRAINT onliners_pkey PRIMARY KEY (id);

ALTER TABLE onliners CLUSTER ON onliners_pkey;


--
-- Name: our_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY our_locations
    ADD CONSTRAINT our_locations_pkey PRIMARY KEY (id);


--
-- Name: ourcal_calendars_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ourcal_calendars
    ADD CONSTRAINT ourcal_calendars_pkey PRIMARY KEY (id);


--
-- Name: ourcal_event_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ourcal_event_locations
    ADD CONSTRAINT ourcal_event_locations_pkey PRIMARY KEY (id);


--
-- Name: ourcal_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ourcal_events
    ADD CONSTRAINT ourcal_events_pkey PRIMARY KEY (id);


--
-- Name: page_hits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY page_hits
    ADD CONSTRAINT page_hits_pkey PRIMARY KEY (id);


--
-- Name: partners_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY partners
    ADD CONSTRAINT partners_pkey PRIMARY KEY (id);


--
-- Name: phase_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY translated_strings
    ADD CONSTRAINT phase_keys_pkey PRIMARY KEY (id);


--
-- Name: phases_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY phases
    ADD CONSTRAINT phases_pkey PRIMARY KEY (id);


--
-- Name: plaques_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY plaques
    ADD CONSTRAINT plaques_pkey PRIMARY KEY (id);


--
-- Name: playlists_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY playlists_items
    ADD CONSTRAINT playlists_items_pkey PRIMARY KEY (id);


--
-- Name: playlists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY playlists
    ADD CONSTRAINT playlists_pkey PRIMARY KEY (id);


--
-- Name: playlists_shared_supervision_playlists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY playlists_shared_supervision_playlists
    ADD CONSTRAINT playlists_shared_supervision_playlists_pkey PRIMARY KEY (id);


--
-- Name: playlists_to_players_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY playlists_to_players
    ADD CONSTRAINT playlists_to_players_pkey PRIMARY KEY (id);


--
-- Name: playlists_user_playlists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY playlists_user_playlists
    ADD CONSTRAINT playlists_user_playlists_pkey PRIMARY KEY (id);


--
-- Name: points_item_offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY points_item_offers
    ADD CONSTRAINT points_item_offers_pkey PRIMARY KEY (id);


--
-- Name: points_item_purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY points_item_purchases
    ADD CONSTRAINT points_item_purchases_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: predictors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY predictors
    ADD CONSTRAINT predictors_pkey PRIMARY KEY (id);


--
-- Name: prize_winners_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prize_winners
    ADD CONSTRAINT prize_winners_pkey PRIMARY KEY (id);


--
-- Name: profile_page_rollups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY profile_page_rollups
    ADD CONSTRAINT profile_page_rollups_pkey PRIMARY KEY (id);


--
-- Name: promo_data_judge_clicks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY promo_data_judge_clicks
    ADD CONSTRAINT promo_data_judge_clicks_pkey PRIMARY KEY (id);


--
-- Name: promo_download_authorizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY promo_download_authorizations
    ADD CONSTRAINT promo_download_authorizations_pkey PRIMARY KEY (id);


--
-- Name: promotion_user_data_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY promotion_user_data_fields
    ADD CONSTRAINT promotion_user_data_fields_pkey PRIMARY KEY (id);


--
-- Name: promotion_user_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY promotion_user_data
    ADD CONSTRAINT promotion_user_data_pkey PRIMARY KEY (id);


--
-- Name: promotions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY promotions
    ADD CONSTRAINT promotions_pkey PRIMARY KEY (id);


--
-- Name: purchasable_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY purchasable_codes
    ADD CONSTRAINT purchasable_codes_pkey PRIMARY KEY (id);


--
-- Name: qaos_user_entry_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY qaos_user_entry_scores
    ADD CONSTRAINT qaos_user_entry_scores_pkey PRIMARY KEY (id);


--
-- Name: radio_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY radio_settings
    ADD CONSTRAINT radio_settings_pkey PRIMARY KEY (id);


--
-- Name: ranks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ranks
    ADD CONSTRAINT ranks_pkey PRIMARY KEY (id);


--
-- Name: recommendations_parameter_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY recommendations_parameter_groups
    ADD CONSTRAINT recommendations_parameter_groups_pkey PRIMARY KEY (id);


--
-- Name: recommendations_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY recommendations_parameters
    ADD CONSTRAINT recommendations_parameters_pkey PRIMARY KEY (id);


--
-- Name: recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY recommendations
    ADD CONSTRAINT recommendations_pkey PRIMARY KEY (id);


--
-- Name: recommended_artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY recommended_artists
    ADD CONSTRAINT recommended_artists_pkey PRIMARY KEY (id);


--
-- Name: recommended_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY recommended_events
    ADD CONSTRAINT recommended_events_pkey PRIMARY KEY (id);


--
-- Name: recommended_songs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY recommended_songs
    ADD CONSTRAINT recommended_songs_pkey PRIMARY KEY (id);


--
-- Name: regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: remote_contests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY remote_contests
    ADD CONSTRAINT remote_contests_pkey PRIMARY KEY (id);


--
-- Name: requested_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY requested_items
    ADD CONSTRAINT requested_items_pkey PRIMARY KEY (id);


--
-- Name: rev_share_defaults_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rev_share_defaults
    ADD CONSTRAINT rev_share_defaults_pkey PRIMARY KEY (id);


--
-- Name: rev_share_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rev_share_periods
    ADD CONSTRAINT rev_share_periods_pkey PRIMARY KEY (id);


--
-- Name: rev_share_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rev_share_records
    ADD CONSTRAINT rev_share_records_pkey PRIMARY KEY (id);


--
-- Name: rev_share_rollups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rev_share_rollups
    ADD CONSTRAINT rev_share_rollups_pkey PRIMARY KEY (id);


--
-- Name: rev_share_tier_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rev_share_tier_sets
    ADD CONSTRAINT rev_share_tier_sets_pkey PRIMARY KEY (id);


--
-- Name: rev_share_tiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rev_share_tiers
    ADD CONSTRAINT rev_share_tiers_pkey PRIMARY KEY (id);


--
-- Name: role_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY role_groups
    ADD CONSTRAINT role_groups_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: scene_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY scene_memberships
    ADD CONSTRAINT scene_memberships_pkey PRIMARY KEY (id);


--
-- Name: scenes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY scenes
    ADD CONSTRAINT scenes_pkey PRIMARY KEY (id);


--
-- Name: schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- Name: score_factors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY score_factors
    ADD CONSTRAINT score_factors_pkey PRIMARY KEY (id);


--
-- Name: scripts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY games_talent_scripts
    ADD CONSTRAINT scripts_pkey PRIMARY KEY (id);


--
-- Name: search_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY search_locations
    ADD CONSTRAINT search_locations_pkey PRIMARY KEY (id);


--
-- Name: searched_strings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY searched_strings
    ADD CONSTRAINT searched_strings_pkey PRIMARY KEY (id);


--
-- Name: send_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY send_items
    ADD CONSTRAINT send_entries_pkey PRIMARY KEY (id);


--
-- Name: site_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY site_actions
    ADD CONSTRAINT site_actions_pkey PRIMARY KEY (id);


--
-- Name: site_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY site_visits
    ADD CONSTRAINT site_visits_pkey PRIMARY KEY (id);


--
-- Name: sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: sms_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sms_codes
    ADD CONSTRAINT sms_codes_pkey PRIMARY KEY (id);


--
-- Name: sms_contests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sms_contests
    ADD CONSTRAINT sms_contests_pkey PRIMARY KEY (id);


--
-- Name: sms_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sms_entries
    ADD CONSTRAINT sms_entries_pkey PRIMARY KEY (id);


--
-- Name: stage_plot_elements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stage_plot_elements
    ADD CONSTRAINT stage_plot_elements_pkey PRIMARY KEY (id);


--
-- Name: stage_plots_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stage_plots
    ADD CONSTRAINT stage_plots_pkey PRIMARY KEY (id);


--
-- Name: subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: subscriptions_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subscriptions_plans
    ADD CONSTRAINT subscriptions_plans_pkey PRIMARY KEY (id);


--
-- Name: subscriptions_purchased_songs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subscriptions_purchased_songs
    ADD CONSTRAINT subscriptions_purchased_songs_pkey PRIMARY KEY (id);


--
-- Name: supervision_downloads_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supervision_downloads
    ADD CONSTRAINT supervision_downloads_pkey PRIMARY KEY (id);


--
-- Name: supervision_search_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supervision_search_terms
    ADD CONSTRAINT supervision_search_terms_pkey PRIMARY KEY (id);


--
-- Name: supervision_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supervision_searches
    ADD CONSTRAINT supervision_searches_pkey PRIMARY KEY (id);


--
-- Name: supervisor_media_item_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supervisor_media_item_reviews
    ADD CONSTRAINT supervisor_media_item_reviews_pkey PRIMARY KEY (id);


--
-- Name: tag_counts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tag_counts_old
    ADD CONSTRAINT tag_counts_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags_old
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey1; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey1 PRIMARY KEY (id);


--
-- Name: talent_battles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY games_talent_battles
    ADD CONSTRAINT talent_battles_pkey PRIMARY KEY (id);


--
-- Name: talent_games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY games_talent_games
    ADD CONSTRAINT talent_games_pkey PRIMARY KEY (id);


--
-- Name: talent_ranks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY games_talent_ranks
    ADD CONSTRAINT talent_ranks_pkey PRIMARY KEY (id);


--
-- Name: talent_rounds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY games_talent_rounds
    ADD CONSTRAINT talent_rounds_pkey PRIMARY KEY (id);


--
-- Name: taste_space2_cluster_trees_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taste_space2_cluster_trees
    ADD CONSTRAINT taste_space2_cluster_trees_pkey PRIMARY KEY (id);


--
-- Name: taste_space2_clusters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taste_space2_clusters
    ADD CONSTRAINT taste_space2_clusters_pkey PRIMARY KEY (id);


--
-- Name: taste_space2_disorders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taste_space2_disorders
    ADD CONSTRAINT taste_space2_disorders_pkey PRIMARY KEY (id);


--
-- Name: taste_space2_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taste_space2_points
    ADD CONSTRAINT taste_space2_points_pkey PRIMARY KEY (id);


--
-- Name: taste_space2_spaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taste_space2_spaces
    ADD CONSTRAINT taste_space2_spaces_pkey PRIMARY KEY (id);


--
-- Name: taste_space_user_disorders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taste_space_user_disorders
    ADD CONSTRAINT taste_space_user_disorders_pkey PRIMARY KEY (id);


--
-- Name: thread_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY thread_messages
    ADD CONSTRAINT thread_messages_pkey PRIMARY KEY (id);


--
-- Name: travis_artist_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY travis_artist_stats
    ADD CONSTRAINT travis_artist_stats_pkey PRIMARY KEY (id);


--
-- Name: travis_radio_format_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY travis_radio_format_channels
    ADD CONSTRAINT travis_radio_format_channels_pkey PRIMARY KEY (id);


--
-- Name: travis_radio_formats_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY travis_radio_formats
    ADD CONSTRAINT travis_radio_formats_pkey PRIMARY KEY (id);


--
-- Name: travis_track_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY travis_track_stats
    ADD CONSTRAINT travis_track_stats_pkey PRIMARY KEY (id);


--
-- Name: user_fb_event_pending_scrapes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_fb_event_pending_scrapes
    ADD CONSTRAINT user_fb_event_pending_scrapes_pkey PRIMARY KEY (id);


--
-- Name: user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (id);


--
-- Name: user_infos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_infos
    ADD CONSTRAINT user_infos_pkey PRIMARY KEY (id);


--
-- Name: user_regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_regions
    ADD CONSTRAINT user_regions_pkey PRIMARY KEY (id);


--
-- Name: user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: user_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_tags_old
    ADD CONSTRAINT user_tags_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_about_mes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_about_mes
    ADD CONSTRAINT users_block_data_about_mes_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_achievement_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_achievement_lists
    ADD CONSTRAINT users_block_data_achievement_lists_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_artist_feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_artist_feeds
    ADD CONSTRAINT users_block_data_artist_feeds_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_blogs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_blogs
    ADD CONSTRAINT users_block_data_blogs_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_comment_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_comment_lists
    ADD CONSTRAINT users_block_data_comment_lists_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_event_calendars_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_event_calendars
    ADD CONSTRAINT users_block_data_event_calendars_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_fan_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_fan_lists
    ADD CONSTRAINT users_block_data_fan_lists_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_fc_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_fc_memberships
    ADD CONSTRAINT users_block_data_fc_memberships_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_firsts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_firsts
    ADD CONSTRAINT users_block_data_firsts_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_free_tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_free_tracks
    ADD CONSTRAINT users_block_data_free_tracks_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_friend_feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_friend_feeds
    ADD CONSTRAINT users_block_data_friend_feeds_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_friend_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_friend_lists
    ADD CONSTRAINT users_block_data_friend_lists_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_influences_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_influences
    ADD CONSTRAINT users_block_data_influences_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_judge_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_judge_histories
    ADD CONSTRAINT users_block_data_judge_histories_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_link_boxes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_link_boxes
    ADD CONSTRAINT users_block_data_link_boxes_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_live_feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_live_feeds
    ADD CONSTRAINT users_block_data_live_feeds_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_media_item_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_media_item_lists
    ADD CONSTRAINT users_block_data_media_item_lists_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_music_favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_music_favorites
    ADD CONSTRAINT users_block_data_music_favorites_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_music_maps_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_music_maps
    ADD CONSTRAINT users_block_data_music_maps_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_music_players_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_music_players
    ADD CONSTRAINT users_block_data_music_players_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_my_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_my_accounts
    ADD CONSTRAINT users_block_data_my_accounts_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_photo_galleries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_photo_galleries
    ADD CONSTRAINT users_block_data_photo_galleries_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_stage_specs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_stage_specs
    ADD CONSTRAINT users_block_data_stage_specs_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_venue_infos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_venue_infos
    ADD CONSTRAINT users_block_data_venue_infos_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_video_favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_video_favorites
    ADD CONSTRAINT users_block_data_video_favorites_pkey PRIMARY KEY (id);


--
-- Name: users_block_data_video_players_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_block_data_video_players
    ADD CONSTRAINT users_block_data_video_players_pkey PRIMARY KEY (id);


--
-- Name: users_deferred_earnings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_deferred_earnings
    ADD CONSTRAINT users_deferred_earnings_pkey PRIMARY KEY (id);


--
-- Name: users_demographics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_demographics
    ADD CONSTRAINT users_demographics_pkey PRIMARY KEY (id);


--
-- Name: users_donations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_donations
    ADD CONSTRAINT users_donations_pkey PRIMARY KEY (id);


--
-- Name: users_external_uris_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_external_uris
    ADD CONSTRAINT users_external_uris_pkey PRIMARY KEY (id);


--
-- Name: users_finance_rollups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_finance_rollups
    ADD CONSTRAINT users_finance_rollups_pkey PRIMARY KEY (id);


--
-- Name: users_finances_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_finances
    ADD CONSTRAINT users_finances_pkey PRIMARY KEY (id);


--
-- Name: users_friendships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_friendships
    ADD CONSTRAINT users_friendships_pkey PRIMARY KEY (id);


--
-- Name: users_photo_galleries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_photo_galleries
    ADD CONSTRAINT users_photo_galleries_pkey PRIMARY KEY (id);


--
-- Name: users_photo_gallery_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_photo_gallery_items
    ADD CONSTRAINT users_photo_gallery_items_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_profile_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_profile_blocks
    ADD CONSTRAINT users_profile_blocks_pkey PRIMARY KEY (id);


--
-- Name: users_profile_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_profile_links
    ADD CONSTRAINT users_profile_links_pkey PRIMARY KEY (id);


--
-- Name: users_profile_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_profile_pages
    ADD CONSTRAINT users_profile_pages_pkey PRIMARY KEY (id);


--
-- Name: users_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_profiles
    ADD CONSTRAINT users_profiles_pkey PRIMARY KEY (id);


--
-- Name: users_user_uris_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_user_uris
    ADD CONSTRAINT users_user_uris_pkey PRIMARY KEY (id);


--
-- Name: util_our_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY util_our_stats
    ADD CONSTRAINT util_our_stats_pkey PRIMARY KEY (id);


--
-- Name: util_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY util_parameters
    ADD CONSTRAINT util_parameters_pkey PRIMARY KEY (id);


--
-- Name: vote_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vote_records
    ADD CONSTRAINT vote_records_pkey PRIMARY KEY (id);


--
-- Name: welcome_page_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY welcome_page_emails
    ADD CONSTRAINT welcome_page_emails_pkey PRIMARY KEY (id);


--
-- Name: widget_giveaways_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY widget_giveaways
    ADD CONSTRAINT widget_giveaways_pkey PRIMARY KEY (id);


--
-- Name: widget_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY widget_sessions
    ADD CONSTRAINT widget_sessions_pkey PRIMARY KEY (id);


--
-- Name: widgets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY widgets
    ADD CONSTRAINT widgets_pkey PRIMARY KEY (id);


--
-- Name: word_press_authors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word_press_authors
    ADD CONSTRAINT word_press_authors_pkey PRIMARY KEY (id);


--
-- Name: word_press_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word_press_categories
    ADD CONSTRAINT word_press_categories_pkey PRIMARY KEY (id);


--
-- Name: word_press_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word_press_posts
    ADD CONSTRAINT word_press_posts_pkey PRIMARY KEY (id);


--
-- Name: word_press_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word_press_tags
    ADD CONSTRAINT word_press_tags_pkey PRIMARY KEY (id);


--
-- Name: account_actions_by_admin_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX account_actions_by_admin_id ON account_actions USING btree (admin_id);


--
-- Name: account_actions_by_media_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX account_actions_by_media_id ON account_actions USING btree (media_item_id);


--
-- Name: account_actions_by_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX account_actions_by_user_id ON account_actions USING btree (account_user_id);


--
-- Name: achievements_by_plaque; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX achievements_by_plaque ON achievements USING btree (plaque_id);


--
-- Name: activation_requests_by_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX activation_requests_by_user ON activation_requests USING btree (user_id);


--
-- Name: anon_users_by_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX anon_users_by_date ON anonymous_user_records USING btree (created_at);


--
-- Name: anonymous_ip_addresses; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX anonymous_ip_addresses ON anonymous_user_records USING btree (ip);


--
-- Name: answers_by_artist_and_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX answers_by_artist_and_type ON marketplace_artist_info_answers USING btree (user_id, question_enum);


--
-- Name: auto_complete_tags; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX auto_complete_tags ON tags_old USING btree (name, flags);


--
-- Name: background_task_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX background_task_state ON background_task_logs USING btree (state);


--
-- Name: banner_hits_by_entry_style_and_referrer; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX banner_hits_by_entry_style_and_referrer ON banner_hits USING btree (entry_id, banner_style, referrer);


--
-- Name: banner_hits_by_last_view; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX banner_hits_by_last_view ON banner_hits USING btree (last_viewed_at);


--
-- Name: battles_by_entry1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX battles_by_entry1 ON battles USING btree (entry_1_id);


--
-- Name: battles_by_entry2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX battles_by_entry2 ON battles USING btree (entry_2_id);


--
-- Name: battles_by_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX battles_by_time ON battles USING btree (scored_at);


--
-- Name: by_activation_code_unique; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX by_activation_code_unique ON activation_requests USING btree (activation_code);


--
-- Name: cart_items_by_media_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX cart_items_by_media_id ON cart_items USING btree (media_item_id);


--
-- Name: checksum_md5_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX checksum_md5_index ON checksums USING btree (md5);


--
-- Name: classified_responses_by_thread; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX classified_responses_by_thread ON thread_messages USING btree (thread_id);


--
-- Name: classified_responses_by_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX classified_responses_by_user ON thread_messages USING btree (thread_id, user_id);


--
-- Name: comments_by_commentable; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX comments_by_commentable ON comments USING btree (commentable_id);


--
-- Name: complaints_by_entry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX complaints_by_entry ON complaints USING btree (entry_id);


--
-- Name: complaints_by_listing; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX complaints_by_listing ON complaints USING btree (listing_key);


--
-- Name: complaints_by_media_assets_image; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX complaints_by_media_assets_image ON complaints USING btree (media_assets_image_id);


--
-- Name: complaints_by_media_item; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX complaints_by_media_item ON complaints USING btree (media_item_id);


--
-- Name: complaints_by_sms_entry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX complaints_by_sms_entry ON complaints USING btree (sms_entry_id);


--
-- Name: complaints_by_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX complaints_by_status ON complaints USING btree (review_status);


--
-- Name: complaints_by_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX complaints_by_user ON complaints USING btree (user_id);


--
-- Name: contest_entry_rank_track; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX contest_entry_rank_track ON entry_rank_trackers USING btree (contest_id, entry_id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: deleted_letters; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX deleted_letters ON letters USING btree (deleted);


--
-- Name: display_name_remove_me; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX display_name_remove_me ON users USING btree (display_name);


--
-- Name: editable_block_asset_views_asset; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX editable_block_asset_views_asset ON editable_block_asset_views USING btree (editable_block_asset_id);


--
-- Name: embedded_players_entries; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX embedded_players_entries ON embedded_players USING btree (entry_id);


--
-- Name: entries_by_mediaitem; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX entries_by_mediaitem ON entries USING btree (media_item_id);


--
-- Name: entry_id_views; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX entry_id_views ON entry_views USING btree (entry_id);


--
-- Name: entry_selects_contests; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX entry_selects_contests ON entry_selects USING btree (contest_id);


--
-- Name: entry_selects_entries; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX entry_selects_entries ON entry_selects USING btree (entry_id);


--
-- Name: entry_selects_ordinal; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX entry_selects_ordinal ON entry_selects USING btree (ordinal);


--
-- Name: entry_selects_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX entry_selects_priority ON entry_selects USING btree (priority);


--
-- Name: entry_stats_by_entry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX entry_stats_by_entry ON demo_entry_statistics USING btree (entry_id);


--
-- Name: entry_views_by_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX entry_views_by_time ON entry_views USING btree (created_at);


--
-- Name: entry_views_by_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX entry_views_by_user ON entry_views USING btree (user_id, entry_id);


--
-- Name: events_events_by_venue; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX events_events_by_venue ON events_events USING btree (venue_id);


--
-- Name: external_events_with_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX external_events_with_user ON events_externals USING btree (event_id, user_id);


--
-- Name: feed_refers_by_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX feed_refers_by_user ON feed_refers USING btree (user_id, created_at DESC);


--
-- Name: feed_refers_by_user_and_blurb; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX feed_refers_by_user_and_blurb ON feed_refers USING btree (user_id, feed_blurb_id);


--
-- Name: for_date_range; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX for_date_range ON rev_share_periods USING btree (start_date, end_date);


--
-- Name: for_period; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX for_period ON rev_share_records USING btree (period_id);


--
-- Name: google_tokens_by_user_and_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX google_tokens_by_user_and_type ON google_tokens USING btree (user_id, token_type);


--
-- Name: index_achievements_on_period; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_achievements_on_period ON achievements USING btree (period);


--
-- Name: index_achievements_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_achievements_on_user_id ON achievements USING btree (user_id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_admin_notes_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_admin_notes_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_artist_referrals_email_address; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_artist_referrals_email_address ON artist_referrals USING btree (email_address);


--
-- Name: index_artist_referrals_user_id_and_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_artist_referrals_user_id_and_created_at ON artist_referrals USING btree (user_id, created_at);


--
-- Name: index_artist_referrals_user_id_and_email_address; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_artist_referrals_user_id_and_email_address ON artist_referrals USING btree (user_id, email_address);


--
-- Name: index_authnet_cim_payment_profiles_on_cim_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authnet_cim_payment_profiles_on_cim_profile_id ON authnet_cim_payment_profiles USING btree (cim_profile_id);


--
-- Name: index_authnet_cim_payment_profiles_on_flags; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authnet_cim_payment_profiles_on_flags ON authnet_cim_payment_profiles USING btree (flags);


--
-- Name: index_authnet_cim_profiles_on_billable_id_and_billable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_authnet_cim_profiles_on_billable_id_and_billable_type ON authnet_cim_profiles USING btree (billable_id, billable_type);


--
-- Name: index_authnet_cim_shipping_profiles_on_cim_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authnet_cim_shipping_profiles_on_cim_profile_id ON authnet_cim_shipping_profiles USING btree (cim_profile_id);


--
-- Name: index_authorizations_on_access; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authorizations_on_access ON authorizations USING btree (access);


--
-- Name: index_authorizations_on_user_id_and_access; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_authorizations_on_user_id_and_access ON authorizations USING btree (user_id, access);


--
-- Name: index_background_task_logs_on_background_task_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_background_task_logs_on_background_task_id ON background_task_logs USING btree (background_task_id);


--
-- Name: index_background_task_logs_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_background_task_logs_on_state ON background_task_logs USING btree (state);


--
-- Name: index_background_tasks_on_next_run_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_background_tasks_on_next_run_time ON background_tasks USING btree (next_run_time);


--
-- Name: index_background_tasks_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_background_tasks_on_state ON background_tasks USING btree (state);


--
-- Name: index_bands_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_bands_on_key ON bands USING btree (key);


--
-- Name: index_bands_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bands_on_user_id ON bands USING btree (user_id);


--
-- Name: index_battle_behavior_ratings_on_contest_id_and_user_id_and_beh; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_battle_behavior_ratings_on_contest_id_and_user_id_and_beh ON battle_behavior_ratings USING btree (contest_id, user_id, behavior_class_name, battle_type);


--
-- Name: index_battle_behavior_ratings_on_rating; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_battle_behavior_ratings_on_rating ON battle_behavior_ratings USING btree (rating);


--
-- Name: index_battle_behavior_ratings_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_battle_behavior_ratings_on_user_id ON battle_behavior_ratings USING btree (user_id);


--
-- Name: index_cart_items_on_cart_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cart_items_on_cart_id ON cart_items USING btree (cart_id);


--
-- Name: index_carts_on_fav_artist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_carts_on_fav_artist_id ON carts USING btree (fav_artist_id);


--
-- Name: index_carts_on_fulfilled_on; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_carts_on_fulfilled_on ON carts USING btree (fulfilled_on);


--
-- Name: index_carts_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_carts_on_key ON carts USING btree (key);


--
-- Name: index_carts_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_carts_on_user_id ON carts USING btree (user_id);


--
-- Name: index_catalog_item_photos_on_catalog_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_catalog_item_photos_on_catalog_item_id ON catalog_item_photos USING btree (catalog_item_id);


--
-- Name: index_catalog_items_on_inventory_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_catalog_items_on_inventory_item_id ON catalog_items USING btree (inventory_item_id);


--
-- Name: index_channel_genres_on_genre_id_and_channel_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_channel_genres_on_genre_id_and_channel_id ON channel_genres USING btree (genre_id, channel_id);


--
-- Name: index_channels_gigs_on_channel_id_and_gig_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_channels_gigs_on_channel_id_and_gig_id ON channels_gigs USING btree (channel_id, gig_id);


--
-- Name: index_chart_items_on_chart_id_and_ordinal; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_chart_items_on_chart_id_and_ordinal ON chart_items USING btree (chart_id, ordinal);


--
-- Name: index_charts_best_of_best_approvals_on_artist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_charts_best_of_best_approvals_on_artist_id ON charts_best_of_best_approvals USING btree (artist_id);


--
-- Name: index_charts_best_of_best_genres_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_charts_best_of_best_genres_on_key ON charts_best_of_best_genres USING btree (key);


--
-- Name: index_charts_categories_on_klass_and_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_charts_categories_on_klass_and_key ON charts_categories USING btree (klass, key);


--
-- Name: index_charts_charts_unique; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_charts_charts_unique ON charts_charts USING btree (chartable_type, chartable_id, end_at, charts_category_id, start_at);


--
-- Name: index_charts_on_channel_id_and_chart_type_and_week_of; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_charts_on_channel_id_and_chart_type_and_week_of ON charts USING btree (channel_id, chart_type, week_of);


--
-- Name: index_charts_positions_on_charts_chart_id_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_charts_positions_on_charts_chart_id_and_item_id ON charts_positions USING btree (charts_chart_id, item_id);


--
-- Name: index_charts_positions_on_charts_chart_id_and_ordinal; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_charts_positions_on_charts_chart_id_and_ordinal ON charts_positions USING btree (charts_chart_id, ordinal);


--
-- Name: index_classify_genres_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_classify_genres_on_key ON classify_genres USING btree (key);


--
-- Name: index_classify_genres_on_lft; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_classify_genres_on_lft ON classify_genres USING btree (lft);


--
-- Name: index_classify_genres_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_classify_genres_on_parent_id ON classify_genres USING btree (parent_id);


--
-- Name: index_classify_genres_on_rgt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_classify_genres_on_rgt ON classify_genres USING btree (rgt);


--
-- Name: index_classify_media_item_genres_on_genre_id_and_media_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_classify_media_item_genres_on_genre_id_and_media_item_id ON classify_media_item_genres USING btree (genre_id, media_item_id);


--
-- Name: index_classify_media_item_genres_on_media_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_classify_media_item_genres_on_media_item_id ON classify_media_item_genres USING btree (media_item_id);


--
-- Name: index_contests_on_promotion_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_contests_on_promotion_id ON contests USING btree (promotion_id);


--
-- Name: index_custom_registrations_on_promotion_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_custom_registrations_on_promotion_id ON custom_registrations USING btree (promotion_id);


--
-- Name: index_demo_battles_on_entry_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_demo_battles_on_entry_id_and_user_id ON demo_battles USING btree (entry_id, user_id);


--
-- Name: index_demo_entry_statistics_on_state_and_demo_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_demo_entry_statistics_on_state_and_demo_group_id ON demo_entry_statistics USING btree (state, demo_group_id);


--
-- Name: index_demo_user_groups_on_demo_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_demo_user_groups_on_demo_group_id ON demo_user_groups USING btree (demo_group_id);


--
-- Name: index_demo_user_groups_on_user_id_and_demo_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_demo_user_groups_on_user_id_and_demo_group_id ON demo_user_groups USING btree (user_id, demo_group_id);


--
-- Name: index_dismissed_dialogs_on_user_id_and_which; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_dismissed_dialogs_on_user_id_and_which ON dismissed_dialogs USING btree (user_id, which);


--
-- Name: index_ecommerce_inventory_items_on_item_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ecommerce_inventory_items_on_item_type ON ecommerce_inventory_items USING btree (item_type);


--
-- Name: index_ecommerce_invoice_ship_addresses_on_invoice_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ecommerce_invoice_ship_addresses_on_invoice_id ON ecommerce_invoice_ship_addresses USING btree (invoice_id);


--
-- Name: index_ecommerce_invoices_on_cart_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ecommerce_invoices_on_cart_id ON ecommerce_invoices USING btree (cart_id);


--
-- Name: index_ecommerce_subscriptions_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ecommerce_subscriptions_on_created_at ON ecommerce_subscriptions USING btree (created_at);


--
-- Name: index_editorial_blocks_on_activation_task_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_editorial_blocks_on_activation_task_id ON editorial_blocks USING btree (activation_task_id);


--
-- Name: index_editorial_blocks_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_editorial_blocks_on_key ON editorial_blocks USING btree (key);


--
-- Name: index_entries_on_channel_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_entries_on_channel_id ON entries USING btree (channel_id);


--
-- Name: index_epk_answers_on_epk_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_epk_answers_on_epk_id ON epk_answers USING btree (epk_id);


--
-- Name: index_event_source_genres_on_classify_genre_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_event_source_genres_on_classify_genre_id ON event_source_genres USING btree (classify_genre_id);


--
-- Name: index_event_source_genres_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_event_source_genres_on_name ON event_source_genres USING btree (name);


--
-- Name: index_events_events_on_creator_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_events_on_creator_id ON events_events USING btree (creator_id);


--
-- Name: index_events_events_on_external_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_events_on_external_id ON events_events USING btree (external_id);


--
-- Name: index_events_genres_on_classify_genre_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_genres_on_classify_genre_id ON events_genres USING btree (classify_genre_id);


--
-- Name: index_events_genres_on_event_source_genre_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_genres_on_event_source_genre_id ON events_genres USING btree (event_source_genre_id);


--
-- Name: index_events_genres_on_events_event_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_genres_on_events_event_id ON events_genres USING btree (events_event_id);


--
-- Name: index_events_performers_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_performers_name ON events_performers USING btree (name);


--
-- Name: index_events_performers_name_lcase; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_performers_name_lcase ON events_performers USING btree (lower((name)::text));


--
-- Name: index_events_performers_on_external_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_performers_on_external_id ON events_performers USING btree (external_id);


--
-- Name: index_events_performers_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_performers_on_user_id ON events_performers USING btree (user_id);


--
-- Name: index_events_presenters_on_events_event_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_presenters_on_events_event_id ON events_presenters USING btree (events_event_id);


--
-- Name: index_events_presenters_on_events_performer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_presenters_on_events_performer_id ON events_presenters USING btree (events_performer_id);


--
-- Name: index_events_venues_on_external_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_venues_on_external_id ON events_venues USING btree (external_id);


--
-- Name: index_events_venues_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_venues_on_user_id ON events_venues USING btree (user_id);


--
-- Name: index_experiments_on_active; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_experiments_on_active ON experiments USING btree (active);


--
-- Name: index_experiments_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_experiments_on_key ON experiments USING btree (key);


--
-- Name: index_facebook_accounts_on_facebook_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_facebook_accounts_on_facebook_id ON facebook_accounts USING btree (facebook_id);


--
-- Name: index_facebook_accounts_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_facebook_accounts_on_user_id ON facebook_accounts USING btree (user_id);


--
-- Name: index_facebook_api_keys_on_api_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_facebook_api_keys_on_api_key ON facebook_api_keys USING btree (api_key);


--
-- Name: index_facebook_api_keys_on_app_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_facebook_api_keys_on_app_id ON facebook_api_keys USING btree (app_id);


--
-- Name: index_facebook_templates_on_template_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_facebook_templates_on_template_name ON facebook_templates USING btree (template_name);


--
-- Name: index_fans_on_fan_club_id_and_is_recommended; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_fans_on_fan_club_id_and_is_recommended ON fans USING btree (fan_club_id, is_recommended);


--
-- Name: index_fans_on_user_id_and_is_recommended; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_fans_on_user_id_and_is_recommended ON fans USING btree (user_id, is_recommended);


--
-- Name: index_feed_blurbs_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feed_blurbs_on_user_id ON feed_blurbs USING btree (user_id);


--
-- Name: index_feed_mills_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feed_mills_on_key ON feed_mills USING btree (key);


--
-- Name: index_form_letters_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_form_letters_on_name ON form_letters USING btree (name);


--
-- Name: index_genre_prefs_on_user_id_session_key_and_genre_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_genre_prefs_on_user_id_session_key_and_genre_id ON genre_prefs USING btree (user_id, session_key, genre_id);


--
-- Name: index_geo_searches_on_canonical_loc_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_geo_searches_on_canonical_loc_name ON geo_searches USING btree (canonical_loc_name);


--
-- Name: index_item_lists_on_list_type_and_scope; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_item_lists_on_list_type_and_scope ON item_lists USING btree (list_type, scope);


--
-- Name: index_limbo_battles_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_limbo_battles_on_user_id ON limbo_battles USING btree (user_id);


--
-- Name: index_live_chat_rooms_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_live_chat_rooms_on_user_id ON live_chat_rooms USING btree (user_id);


--
-- Name: index_live_feed_items_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_live_feed_items_on_created_at ON live_feed_items USING btree (created_at);


--
-- Name: index_live_user_states_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_live_user_states_on_user_id ON live_user_states USING btree (user_id);


--
-- Name: index_locks_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_locks_on_key ON locks USING btree (key);


--
-- Name: index_market_place_epks_on_stage_plot_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_market_place_epks_on_stage_plot_id ON market_place_epks USING btree (stage_plot_id);


--
-- Name: index_market_place_presses_on_venue_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_market_place_presses_on_venue_id ON market_place_presses USING btree (venue_id);


--
-- Name: index_marketplace_applicant_payments_on_applicant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_marketplace_applicant_payments_on_applicant_id ON marketplace_applicant_payments USING btree (applicant_id);


--
-- Name: index_marketplace_applicants_on_gig_id_and_artist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_marketplace_applicants_on_gig_id_and_artist_id ON marketplace_applicants USING btree (gig_id, artist_id);


--
-- Name: index_marketplace_applicants_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_marketplace_applicants_on_key ON marketplace_applicants USING btree (key);


--
-- Name: index_marketplace_artist_info_answers_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_marketplace_artist_info_answers_on_user_id ON marketplace_artist_info_answers USING btree (user_id);


--
-- Name: index_marketplace_artist_scores_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_marketplace_artist_scores_on_user_id ON marketplace_artist_scores USING btree (user_id);


--
-- Name: index_marketplace_channel_scores_on_channel_id_and_points; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_marketplace_channel_scores_on_channel_id_and_points ON marketplace_channel_scores USING btree (channel_id, points);


--
-- Name: index_marketplace_channel_scores_on_channel_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_marketplace_channel_scores_on_channel_id_and_user_id ON marketplace_channel_scores USING btree (channel_id, user_id);


--
-- Name: index_marketplace_contest_categories_on_venue_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_marketplace_contest_categories_on_venue_id ON marketplace_contest_categories USING btree (venue_id);


--
-- Name: index_marketplace_contest_items_on_applicant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_marketplace_contest_items_on_applicant_id ON marketplace_contest_items USING btree (applicant_id);


--
-- Name: index_marketplace_evaluations_on_venue_id_and_artist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_marketplace_evaluations_on_venue_id_and_artist_id ON marketplace_venue_artist_categories USING btree (venue_id, artist_id);


--
-- Name: index_marketplace_filters_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_marketplace_filters_on_user_id ON marketplace_filters USING btree (user_id);


--
-- Name: index_marketplace_gig_actions_on_applicant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_marketplace_gig_actions_on_applicant_id ON marketplace_gig_actions USING btree (applicant_id);


--
-- Name: index_marketplace_gig_actions_on_gig_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_marketplace_gig_actions_on_gig_id ON marketplace_gig_actions USING btree (gig_id);


--
-- Name: index_marketplace_gig_agent_logs_on_artist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_marketplace_gig_agent_logs_on_artist_id ON marketplace_gig_agent_logs USING btree (artist_id);


--
-- Name: index_marketplace_gig_agent_logs_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_marketplace_gig_agent_logs_on_created_at ON marketplace_gig_agent_logs USING btree (created_at);


--
-- Name: index_marketplace_gig_agent_logs_on_gig_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_marketplace_gig_agent_logs_on_gig_id ON marketplace_gig_agent_logs USING btree (gig_id);


--
-- Name: index_marketplace_gigs_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_marketplace_gigs_on_key ON marketplace_gigs USING btree (key);


--
-- Name: index_marketplace_gigs_on_venue_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_marketplace_gigs_on_venue_id ON marketplace_gigs USING btree (venue_id);


--
-- Name: index_marketplace_venue_artist_rating_comments_on_artist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_marketplace_venue_artist_rating_comments_on_artist_id ON marketplace_venue_artist_rating_comments USING btree (artist_id);


--
-- Name: index_marketplace_venue_artist_rating_comments_on_venue_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_marketplace_venue_artist_rating_comments_on_venue_id ON marketplace_venue_artist_rating_comments USING btree (venue_id);


--
-- Name: index_marketplace_venues_on_menu_img_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_marketplace_venues_on_menu_img_id ON marketplace_venues USING btree (menu_img_id);


--
-- Name: index_marketplace_venues_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_marketplace_venues_on_user_id ON marketplace_venues USING btree (user_id);


--
-- Name: index_media_assets_images_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_media_assets_images_on_key ON media_assets_images USING btree (key);


--
-- Name: index_media_assets_images_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_media_assets_images_on_user_id ON media_assets_images USING btree (user_id);


--
-- Name: index_media_item_play_counts_on_media_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_media_item_play_counts_on_media_item_id ON media_item_play_counts USING btree (media_item_id);


--
-- Name: index_media_item_ratings_on_user_id_and_media_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_media_item_ratings_on_user_id_and_media_item_id ON media_item_ratings USING btree (user_id, media_item_id);


--
-- Name: index_media_item_stats_on_media_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_media_item_stats_on_media_item_id ON media_item_stats USING btree (media_item_id);


--
-- Name: index_media_item_views_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_media_item_views_on_created_at ON media_item_views USING btree (created_at);


--
-- Name: index_media_markets_on_source_and_market_type_and_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_media_markets_on_source_and_market_type_and_name ON media_markets USING btree (source, market_type, name);


--
-- Name: index_media_markets_on_source_and_market_type_and_rank; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_media_markets_on_source_and_market_type_and_rank ON media_markets USING btree (source, market_type, rank);


--
-- Name: index_messages_blasts_on_activate_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_blasts_on_activate_at ON messages_blasts USING btree (activate_at);


--
-- Name: index_messages_blastvelopes_on_user_id_and_unread; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_blastvelopes_on_user_id_and_unread ON messages_blastvelopes USING btree (user_id, unread);


--
-- Name: index_messages_conversations_on_members; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_conversations_on_members ON messages_conversations USING btree (members);


--
-- Name: index_messages_envelopes_on_conversation_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_envelopes_on_conversation_id_and_user_id ON messages_envelopes USING btree (conversation_id, user_id);


--
-- Name: index_messages_envelopes_on_user_id_and_last_message_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_envelopes_on_user_id_and_last_message_at ON messages_envelopes USING btree (user_id, last_message_at);


--
-- Name: index_messages_letters_on_conversation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_letters_on_conversation_id ON messages_letters USING btree (conversation_id);


--
-- Name: index_onliners_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_onliners_on_user_id ON onliners USING btree (user_id);


--
-- Name: index_our_locations_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_our_locations_on_key ON our_locations USING btree (key);


--
-- Name: index_our_locations_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_our_locations_on_name ON our_locations USING btree (name);


--
-- Name: index_ourcal_events_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_ourcal_events_on_key ON ourcal_events USING btree (key);


--
-- Name: index_page_hits_on_owner_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_page_hits_on_owner_user_id ON page_hits USING btree (owner_user_id);


--
-- Name: index_playlists_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_playlists_on_key ON playlists USING btree (key);


--
-- Name: index_playlists_on_user_id_and_fetcher_class; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_playlists_on_user_id_and_fetcher_class ON playlists USING btree (user_id, fetcher_class);


--
-- Name: index_playlists_to_players_on_player_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_playlists_to_players_on_player_id ON playlists_to_players USING btree (player_id);


--
-- Name: index_playlists_user_playlists_on_user_id_and_playlist_id_and_o; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_playlists_user_playlists_on_user_id_and_playlist_id_and_o ON playlists_user_playlists USING btree (user_id, playlist_id, ordinal);


--
-- Name: index_posts_on_user_id_and_perm_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_posts_on_user_id_and_perm_id ON posts USING btree (user_id, perm_id);


--
-- Name: index_profile_page_rollups_on_user_id_and_roll_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_profile_page_rollups_on_user_id_and_roll_type ON profile_page_rollups USING btree (user_id, roll_type);


--
-- Name: index_promo_dl_auth; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_promo_dl_auth ON promo_download_authorizations USING btree (promo_which_requires_login_id, promo_which_allows_access_id);


--
-- Name: index_purchasable_codes_on_claimed_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_purchasable_codes_on_claimed_at ON purchasable_codes USING btree (claimed_at);


--
-- Name: index_purchasable_codes_on_expires_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_purchasable_codes_on_expires_at ON purchasable_codes USING btree (expires_at);


--
-- Name: index_purchasable_codes_on_reserved_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_purchasable_codes_on_reserved_at ON purchasable_codes USING btree (reserved_at);


--
-- Name: index_purchasable_codes_on_reserved_for; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_purchasable_codes_on_reserved_for ON purchasable_codes USING btree (reserved_for);


--
-- Name: index_purchasable_codes_on_reserved_until; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_purchasable_codes_on_reserved_until ON purchasable_codes USING btree (reserved_until);


--
-- Name: index_purchased_songs_on_users_and_date_purchased; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_purchased_songs_on_users_and_date_purchased ON subscriptions_purchased_songs USING btree (user_id, date_purchased);


--
-- Name: index_purchased_songs_on_users_and_media_items; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_purchased_songs_on_users_and_media_items ON subscriptions_purchased_songs USING btree (user_id, media_item_id);


--
-- Name: index_qaos_user_entry_scores_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_qaos_user_entry_scores_on_user_id ON qaos_user_entry_scores USING btree (user_id);


--
-- Name: index_recommendations_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_recommendations_on_created_at ON recommendations USING btree (created_at);


--
-- Name: index_recommendations_on_filter_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_recommendations_on_filter_id ON recommendations USING btree (filter_id);


--
-- Name: index_recommendations_on_media_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_recommendations_on_media_item_id ON recommendations USING btree (media_item_id);


--
-- Name: index_recommendations_on_user_id_and_media_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_recommendations_on_user_id_and_media_item_id ON recommendations USING btree (user_id, media_item_id);


--
-- Name: index_recommendations_parameter_groups_on_min_ratings; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_recommendations_parameter_groups_on_min_ratings ON recommendations_parameter_groups USING btree (min_ratings);


--
-- Name: index_recommendations_parameters_on_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_recommendations_parameters_on_group_id ON recommendations_parameters USING btree (group_id);


--
-- Name: index_recommendations_parameters_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_recommendations_parameters_on_type ON recommendations_parameters USING btree (type);


--
-- Name: index_regions_on_latitude; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_latitude ON regions USING btree (latitude);


--
-- Name: index_regions_on_longitude; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_longitude ON regions USING btree (longitude);


--
-- Name: index_regions_on_region_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_region_type ON regions USING btree (region_type);


--
-- Name: index_rev_share_rollups_on_period_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rev_share_rollups_on_period_id ON rev_share_rollups USING btree (period_id);


--
-- Name: index_rev_share_rollups_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rev_share_rollups_on_user_id ON rev_share_rollups USING btree (user_id);


--
-- Name: index_rev_share_tiers_on_tier_set_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rev_share_tiers_on_tier_set_id ON rev_share_tiers USING btree (tier_set_id);


--
-- Name: index_sms_codes_on_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sms_codes_on_code ON sms_codes USING btree (code);


--
-- Name: index_sms_codes_on_prefix_and_used; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sms_codes_on_prefix_and_used ON sms_codes USING btree (prefix, used);


--
-- Name: index_sms_entries_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sms_entries_on_key ON sms_entries USING btree (key);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_tag_id ON taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_type_and_taggable_id_and_context; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_taggable_type_and_taggable_id_and_context ON taggings USING btree (taggable_type, taggable_id, context);


--
-- Name: index_taggings_trusteds_on_context; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_trusteds_on_context ON taggings_trusteds USING btree (context);


--
-- Name: index_taggings_trusteds_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_trusteds_on_tag_id ON taggings_trusteds USING btree (tag_id);


--
-- Name: index_taggings_trusteds_on_taggable_type_and_taggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_trusteds_on_taggable_type_and_taggable_id ON taggings_trusteds USING btree (taggable_type, taggable_id);


--
-- Name: index_tags_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_tags_on_key ON tags USING btree (key);


--
-- Name: index_taste_space2_cluster_trees_on_space_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taste_space2_cluster_trees_on_space_id ON taste_space2_cluster_trees USING btree (space_id);


--
-- Name: index_taste_space2_clusters_on_cluster_tree_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taste_space2_clusters_on_cluster_tree_id ON taste_space2_clusters USING btree (cluster_tree_id);


--
-- Name: index_taste_space2_disorders_on_space_id_and_disorder; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taste_space2_disorders_on_space_id_and_disorder ON taste_space2_disorders USING btree (space_id, disorder);


--
-- Name: index_taste_space2_disorders_on_space_id_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_taste_space2_disorders_on_space_id_and_item_id ON taste_space2_disorders USING btree (space_id, item_id);


--
-- Name: index_taste_space2_points_clusters_on_cluster_id_and_point_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_taste_space2_points_clusters_on_cluster_id_and_point_id ON taste_space2_points_clusters USING btree (cluster_id, point_id);


--
-- Name: index_taste_space2_points_clusters_on_point_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taste_space2_points_clusters_on_point_id ON taste_space2_points_clusters USING btree (point_id);


--
-- Name: index_taste_space2_points_on_space_id_and_item_layer_and_item_i; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_taste_space2_points_on_space_id_and_item_layer_and_item_i ON taste_space2_points USING btree (space_id, item_layer, item_id);


--
-- Name: index_taste_space_user_disorders_on_layer_id_and_disorder; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taste_space_user_disorders_on_layer_id_and_disorder ON taste_space_user_disorders USING btree (layer_id, disorder);


--
-- Name: index_taste_space_user_disorders_on_layer_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_taste_space_user_disorders_on_layer_id_and_user_id ON taste_space_user_disorders USING btree (layer_id, user_id);


--
-- Name: index_travis_artist_stats_on_dataset_and_start_date_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_travis_artist_stats_on_dataset_and_start_date_and_user_id ON travis_artist_stats USING btree (dataset, start_date, user_id);


--
-- Name: index_travis_radio_format_channels_on_channel_id_and_travis_rad; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_travis_radio_format_channels_on_channel_id_and_travis_rad ON travis_radio_format_channels USING btree (channel_id, travis_radio_format_id);


--
-- Name: index_travis_radio_format_channels_on_travis_radio_format_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_travis_radio_format_channels_on_travis_radio_format_id ON travis_radio_format_channels USING btree (travis_radio_format_id);


--
-- Name: index_travis_radio_formats_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_travis_radio_formats_on_name ON travis_radio_formats USING btree (name);


--
-- Name: index_travis_track_stats_on_dataset_and_start_date_and_media_it; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_travis_track_stats_on_dataset_and_start_date_and_media_it ON travis_track_stats USING btree (dataset, start_date, media_item_id);


--
-- Name: index_unscored_battles_for_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_unscored_battles_for_user ON battles USING btree (contest_id, battle_type, user_id, ((scored_at IS NULL)));


--
-- Name: index_user_genres; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_genres ON classify_media_item_genres USING btree (creator_id, genre_id);


--
-- Name: index_user_groups_on_manager_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_groups_on_manager_id ON user_groups USING btree (manager_id);


--
-- Name: index_user_groups_on_manager_id_and_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_user_groups_on_manager_id_and_name ON user_groups USING btree (manager_id, name);


--
-- Name: index_user_groups_users_on_user_id_and_user_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_user_groups_users_on_user_id_and_user_group_id ON user_groups_users USING btree (user_id, user_group_id);


--
-- Name: index_user_infos_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_user_infos_on_user_id ON user_infos USING btree (user_id);


--
-- Name: index_user_regions_on_region_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_regions_on_region_id ON user_regions USING btree (region_id);


--
-- Name: index_user_regions_on_user_id_and_region_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_user_regions_on_user_id_and_region_id ON user_regions USING btree (user_id, region_id);


--
-- Name: index_users_block_data_about_mes_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_about_mes_on_block_id ON users_block_data_about_mes USING btree (block_id);


--
-- Name: index_users_block_data_achievement_lists_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_achievement_lists_on_block_id ON users_block_data_achievement_lists USING btree (block_id);


--
-- Name: index_users_block_data_artist_feeds_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_artist_feeds_on_block_id ON users_block_data_artist_feeds USING btree (block_id);


--
-- Name: index_users_block_data_blogs_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_blogs_on_block_id ON users_block_data_blogs USING btree (block_id);


--
-- Name: index_users_block_data_comment_lists_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_comment_lists_on_block_id ON users_block_data_comment_lists USING btree (block_id);


--
-- Name: index_users_block_data_fan_lists_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_fan_lists_on_block_id ON users_block_data_fan_lists USING btree (block_id);


--
-- Name: index_users_block_data_fc_memberships_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_fc_memberships_on_block_id ON users_block_data_fc_memberships USING btree (block_id);


--
-- Name: index_users_block_data_firsts_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_firsts_on_block_id ON users_block_data_firsts USING btree (block_id);


--
-- Name: index_users_block_data_free_tracks_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_free_tracks_on_block_id ON users_block_data_free_tracks USING btree (block_id);


--
-- Name: index_users_block_data_friend_feeds_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_friend_feeds_on_block_id ON users_block_data_friend_feeds USING btree (block_id);


--
-- Name: index_users_block_data_friend_lists_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_friend_lists_on_block_id ON users_block_data_friend_lists USING btree (block_id);


--
-- Name: index_users_block_data_influences_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_influences_on_block_id ON users_block_data_influences USING btree (block_id);


--
-- Name: index_users_block_data_judge_histories_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_judge_histories_on_block_id ON users_block_data_judge_histories USING btree (block_id);


--
-- Name: index_users_block_data_link_boxes_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_link_boxes_on_block_id ON users_block_data_link_boxes USING btree (block_id);


--
-- Name: index_users_block_data_live_feeds_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_live_feeds_on_block_id ON users_block_data_live_feeds USING btree (block_id);


--
-- Name: index_users_block_data_media_item_lists_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_media_item_lists_on_block_id ON users_block_data_media_item_lists USING btree (block_id);


--
-- Name: index_users_block_data_music_favorites_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_music_favorites_on_block_id ON users_block_data_music_favorites USING btree (block_id);


--
-- Name: index_users_block_data_music_maps_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_music_maps_on_block_id ON users_block_data_music_maps USING btree (block_id);


--
-- Name: index_users_block_data_music_players_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_music_players_on_block_id ON users_block_data_music_players USING btree (block_id);


--
-- Name: index_users_block_data_my_accounts_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_my_accounts_on_block_id ON users_block_data_my_accounts USING btree (block_id);


--
-- Name: index_users_block_data_photo_galleries_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_photo_galleries_on_block_id ON users_block_data_photo_galleries USING btree (block_id);


--
-- Name: index_users_block_data_stage_specs_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_stage_specs_on_block_id ON users_block_data_stage_specs USING btree (block_id);


--
-- Name: index_users_block_data_venue_infos_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_venue_infos_on_block_id ON users_block_data_venue_infos USING btree (block_id);


--
-- Name: index_users_block_data_video_favorites_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_video_favorites_on_block_id ON users_block_data_video_favorites USING btree (block_id);


--
-- Name: index_users_block_data_video_players_on_block_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_block_data_video_players_on_block_id ON users_block_data_video_players USING btree (block_id);


--
-- Name: index_users_deferred_earnings_on_cart_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_deferred_earnings_on_cart_id ON users_deferred_earnings USING btree (cart_id);


--
-- Name: index_users_deferred_earnings_on_date_eligible; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_deferred_earnings_on_date_eligible ON users_deferred_earnings USING btree (date_eligible);


--
-- Name: index_users_deferred_earnings_on_invoice_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_deferred_earnings_on_invoice_id ON users_deferred_earnings USING btree (invoice_id);


--
-- Name: index_users_deferred_earnings_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_deferred_earnings_on_user_id ON users_deferred_earnings USING btree (user_id);


--
-- Name: index_users_demographics_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_demographics_on_user_id ON users_demographics USING btree (user_id);


--
-- Name: index_users_donations_on_cart_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_donations_on_cart_id ON users_donations USING btree (cart_id);


--
-- Name: index_users_donations_on_donator_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_donations_on_donator_id ON users_donations USING btree (donator_id);


--
-- Name: index_users_donations_on_recipient_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_donations_on_recipient_id ON users_donations USING btree (recipient_id);


--
-- Name: index_users_external_uris_on_klass_and_last_event_scrape; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_external_uris_on_klass_and_last_event_scrape ON users_external_uris USING btree (klass, last_event_scrape);


--
-- Name: index_users_external_uris_on_last_fb_event_scrape; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_external_uris_on_last_fb_event_scrape ON users_external_uris USING btree (last_event_scrape);


--
-- Name: index_users_finance_rollups_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_finance_rollups_on_user_id ON users_finance_rollups USING btree (user_id);


--
-- Name: index_users_finances_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_finances_on_created_at ON users_finances USING btree (created_at);


--
-- Name: index_users_finances_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_finances_on_user_id ON users_finances USING btree (user_id);


--
-- Name: index_users_friendships_on_friend_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_friendships_on_friend_id ON users_friendships USING btree (friend_id);


--
-- Name: index_users_friendships_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_friendships_on_user_id ON users_friendships USING btree (user_id);


--
-- Name: index_users_on_facebook_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_facebook_uid ON users USING btree (facebook_uid);


--
-- Name: index_users_photo_galleries_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_photo_galleries_on_user_id ON users_photo_galleries USING btree (user_id);


--
-- Name: index_users_photo_gallery_items_on_users_photo_gallery_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_photo_gallery_items_on_users_photo_gallery_id ON users_photo_gallery_items USING btree (users_photo_gallery_id);


--
-- Name: index_users_profile_blocks_on_page_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_profile_blocks_on_page_id ON users_profile_blocks USING btree (page_id);


--
-- Name: index_users_profile_links_on_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_profile_links_on_profile_id ON users_profile_links USING btree (profile_id);


--
-- Name: index_users_profile_pages_on_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_profile_pages_on_profile_id ON users_profile_pages USING btree (profile_id);


--
-- Name: index_users_profiles_on_facebook_page_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_profiles_on_facebook_page_id ON users_profiles USING btree (facebook_page_id);


--
-- Name: index_users_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_profiles_on_user_id ON users_profiles USING btree (user_id);


--
-- Name: index_users_user_uris_on_uri_element; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_user_uris_on_uri_element ON users_user_uris USING btree (uri_element);


--
-- Name: index_users_user_uris_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_user_uris_on_user_id ON users_user_uris USING btree (user_id);


--
-- Name: index_util_parameters_on_data_class_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_util_parameters_on_data_class_name ON util_parameters USING btree (data_class_name);


--
-- Name: index_widget_giveaways_on_widget_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_widget_giveaways_on_widget_id ON widget_giveaways USING btree (widget_id);


--
-- Name: index_widget_sessions_on_key_and_widget_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_widget_sessions_on_key_and_widget_key ON widget_sessions USING btree (key, widget_key);


--
-- Name: index_widgets_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_widgets_on_key ON widgets USING btree (key);


--
-- Name: index_widgets_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_widgets_on_name ON widgets USING btree (name);


--
-- Name: index_word_press_categories_on_category; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_word_press_categories_on_category ON word_press_categories USING btree (category);


--
-- Name: index_word_press_categories_on_word_press_post_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_word_press_categories_on_word_press_post_id ON word_press_categories USING btree (word_press_post_id);


--
-- Name: index_word_press_posts_on_word_press_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_word_press_posts_on_word_press_author_id ON word_press_posts USING btree (word_press_author_id);


--
-- Name: index_word_press_tags_on_tag; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_word_press_tags_on_tag ON word_press_tags USING btree (tag);


--
-- Name: index_word_press_tags_on_word_press_post_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_word_press_tags_on_word_press_post_id ON word_press_tags USING btree (word_press_post_id);


--
-- Name: influence_by_year_month_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX influence_by_year_month_user ON battle_influences USING btree (year, month, user_id);


--
-- Name: item_tag_counts; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX item_tag_counts ON tag_counts_old USING btree (item_type, item_id, tag_count);


--
-- Name: item_tags; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX item_tags ON user_tags_old USING btree (item_type, item_id);


--
-- Name: judging_badges; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX judging_badges ON users USING btree (judging_badge);


--
-- Name: last_view_by_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX last_view_by_user ON entry_views USING btree (user_id, created_at DESC);


--
-- Name: letters_by_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX letters_by_type ON letters USING btree (letter_type, created_at DESC);


--
-- Name: lfi_artists_created_desc_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX lfi_artists_created_desc_index ON live_feed_items USING btree (artist_id, created_at DESC);


--
-- Name: lfi_users_created_desc_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX lfi_users_created_desc_index ON live_feed_items USING btree (user_id, created_at DESC);


--
-- Name: listing_threads_by_users; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX listing_threads_by_users ON listing_threads USING btree (user_id);


--
-- Name: listings_genres; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX listings_genres ON listing_genres USING btree (listing_id, genre_id);


--
-- Name: listings_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX listings_key ON listings USING btree (key);


--
-- Name: listings_latitude; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX listings_latitude ON listings USING btree (latitude);


--
-- Name: listings_longitude; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX listings_longitude ON listings USING btree (longitude);


--
-- Name: listings_threads_by_listings; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX listings_threads_by_listings ON listing_threads USING btree (listing_id);


--
-- Name: locate_tags; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX locate_tags ON tag_counts_old USING btree (item_type, tag_id, tag_count);


--
-- Name: marketplace_channel_scores_by_entry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX marketplace_channel_scores_by_entry ON marketplace_channel_scores USING btree (entry_id);


--
-- Name: media_item_id_entry_views; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX media_item_id_entry_views ON entry_views USING btree (media_item_id);


--
-- Name: media_item_license_agreements_on_media_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX media_item_license_agreements_on_media_item_id ON media_item_license_agreements USING btree (media_item_id);


--
-- Name: media_item_views_media_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX media_item_views_media_item_id ON media_item_views USING btree (media_item_id);


--
-- Name: media_items_by_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX media_items_by_user ON media_items USING btree (user_id);


--
-- Name: mmz_id_zip_state_city_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX mmz_id_zip_state_city_index ON media_market_zipcodes USING btree (media_market_id, zipcode, state, city);


--
-- Name: mmz_zip_state_city_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX mmz_zip_state_city_id_index ON media_market_zipcodes USING btree (zipcode, state, city, media_market_id);


--
-- Name: mojos_best_of_artists_artist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX mojos_best_of_artists_artist_id ON mojos_best_of_artists USING btree (artist_id);


--
-- Name: mojos_best_of_artists_value; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX mojos_best_of_artists_value ON mojos_best_of_artists USING btree (value);


--
-- Name: mojos_best_of_genre_artists_genre_artist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX mojos_best_of_genre_artists_genre_artist_id ON mojos_best_of_genre_artists USING btree (genre, artist_id);


--
-- Name: mojos_best_of_genre_artists_value; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX mojos_best_of_genre_artists_value ON mojos_best_of_genre_artists USING btree (value);


--
-- Name: mojos_best_of_tracks_media_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX mojos_best_of_tracks_media_item_id ON mojos_best_of_tracks USING btree (media_item_id);


--
-- Name: mojos_best_of_tracks_value; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX mojos_best_of_tracks_value ON mojos_best_of_tracks USING btree (value);


--
-- Name: my_black_marks; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX my_black_marks ON message_blockers USING btree (blocked_id);


--
-- Name: my_blacklist; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX my_blacklist ON message_blockers USING btree (user_id);


--
-- Name: my_fans; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX my_fans ON fans USING btree (fan_club_id);


--
-- Name: my_heros; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX my_heros ON fans USING btree (user_id);


--
-- Name: my_tags; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX my_tags ON user_tags_old USING btree (user_id, item_type, item_id);


--
-- Name: ndx-poly-purchasable; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "ndx-poly-purchasable" ON cart_items USING btree (purchasable_id, purchasable_type);


--
-- Name: ndx_claimed_for_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_claimed_for_user ON purchasable_codes USING btree (user_id, claimed_at);


--
-- Name: ndx_fgn_obj_name_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_fgn_obj_name_id ON administration_ignore_object_matches USING btree (foreign_object_model, foreign_object_id);


--
-- Name: ndx_inv_items_by_sku_flags; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_inv_items_by_sku_flags ON ecommerce_inventory_items USING btree (sku, flags);


--
-- Name: ndx_inv_items_by_sku_uniq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX ndx_inv_items_by_sku_uniq ON ecommerce_inventory_items USING btree (sku);


--
-- Name: ndx_invoice_items_by_invoice; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_invoice_items_by_invoice ON ecommerce_invoice_items USING btree (invoice_id);


--
-- Name: ndx_invoice_notes_by_invoice; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_invoice_notes_by_invoice ON ecommerce_invoice_notes USING btree (invoice_id);


--
-- Name: ndx_invoice_txns_by_invoice; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_invoice_txns_by_invoice ON ecommerce_invoice_transactions USING btree (invoice_id);


--
-- Name: ndx_invoices_by_invoiceable_flags_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_invoices_by_invoiceable_flags_created_at ON ecommerce_invoices USING btree (invoiceable_id, invoiceable_type, flags, created_at);


--
-- Name: ndx_invoices_by_linked_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_invoices_by_linked_id ON ecommerce_invoices USING btree (invoiceable_id, invoiceable_type, linked_invoice_id);


--
-- Name: ndx_optgrps_by_item_ordinal; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_optgrps_by_item_ordinal ON ecommerce_inventory_item_optgroups USING btree (inventory_item_id, ordinal);


--
-- Name: ndx_opts_by_optgroup_ordinal; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_opts_by_optgroup_ordinal ON ecommerce_inventory_item_options USING btree (option_group_id, ordinal);


--
-- Name: ndx_our_obj_name_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_our_obj_name_id ON administration_ignore_object_matches USING btree (our_object_model, our_object_id);


--
-- Name: ndx_reserved_for_until; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_reserved_for_until ON purchasable_codes USING btree (reserved_for, reserved_until);


--
-- Name: ndx_subscription_pmt_profile_by_subscrip_ordinal; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_subscription_pmt_profile_by_subscrip_ordinal ON ecommerce_subscription_payment_profiles USING btree (subscription_id, ordinal);


--
-- Name: ndx_subscriptions_notify_flags; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_subscriptions_notify_flags ON ecommerce_subscriptions USING btree (notify_on, flags);


--
-- Name: ndx_subscriptions_payment_flags; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_subscriptions_payment_flags ON ecommerce_subscriptions USING btree (payment_on, flags, pmt_fail_count);


--
-- Name: ndx_subscriptions_subscribable_polymorphic; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ndx_subscriptions_subscribable_polymorphic ON ecommerce_subscriptions USING btree (subscribable_id, subscribable_type);


--
-- Name: objects_to_confidence; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX objects_to_confidence ON administration_ignore_object_matches USING btree (foreign_object_model, foreign_object_id, our_object_model, our_object_id, unsure);


--
-- Name: original_letters; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX original_letters ON envelopes USING btree (letter_id);


--
-- Name: override_by_artist; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX override_by_artist ON marketplace_qualification_overrides USING btree (artist_id);


--
-- Name: override_by_gig_and_artist; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX override_by_gig_and_artist ON marketplace_qualification_overrides USING btree (gig_id, artist_id);


--
-- Name: percent_agree_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX percent_agree_index ON battles USING btree (contest_id, battle_type, entry_1_id, entry_2_id, (((score <> 0) AND (disqualified = 0))));


--
-- Name: playlisting; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX playlisting ON eb_playlist_items USING btree (eb_playlist_id, editable_block_id);


--
-- Name: playlists_items_by_media_item; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX playlists_items_by_media_item ON playlists_items USING btree (media_item_id);


--
-- Name: playlists_items_by_media_item_playlist; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX playlists_items_by_media_item_playlist ON playlists_items USING btree (media_item_id, playlist_id);


--
-- Name: playlists_items_by_playlist; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX playlists_items_by_playlist ON playlists_items USING btree (playlist_id, ordinal);


--
-- Name: poly_transactor; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX poly_transactor ON users_finances USING btree (transactor_id, transactor_type);


--
-- Name: promo_clicks_by_media_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX promo_clicks_by_media_key ON promo_data_judge_clicks USING btree (media_key);


--
-- Name: promo_judge_clicks_by_ip; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX promo_judge_clicks_by_ip ON promo_data_judge_clicks USING btree (ip);


--
-- Name: promo_judge_clicks_by_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX promo_judge_clicks_by_time ON promo_data_judge_clicks USING btree (created_at);


--
-- Name: promotions_end_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX promotions_end_at ON promotions USING btree (end_at);


--
-- Name: promotions_start_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX promotions_start_at ON promotions USING btree (start_at);


--
-- Name: qaos_temp_by_score; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX qaos_temp_by_score ON qaos_temp_entries USING btree (contest_id, score);


--
-- Name: qaos_unique_user_entry_scores_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX qaos_unique_user_entry_scores_index ON qaos_user_entry_scores USING btree (contest_id, phase, entry_id, user_id);


--
-- Name: radio_settings_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX radio_settings_on_user_id ON radio_settings USING btree (user_id);


--
-- Name: ranks_by_entry_and_type_unique; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX ranks_by_entry_and_type_unique ON ranks USING btree (entry_id, rank_type);


--
-- Name: ranks_for_period; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ranks_for_period ON rev_share_rollups USING btree (period_id, qualified_playcount);


--
-- Name: ratings_by_media_item_and_rating; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ratings_by_media_item_and_rating ON media_item_ratings USING btree (media_item_id, rating DESC);


--
-- Name: recipeint_mail; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX recipeint_mail ON envelopes USING btree (user_id);


--
-- Name: recipient_mail_by_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX recipient_mail_by_status ON envelopes USING btree (user_id, status);


--
-- Name: role_groups_by_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX role_groups_by_name ON role_groups USING btree (name);


--
-- Name: rsvps_by_event; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rsvps_by_event ON events_rsvps USING btree (event_id);


--
-- Name: rsvps_by_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX rsvps_by_user ON events_rsvps USING btree (user_id);


--
-- Name: score_factors_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX score_factors_on_user_id ON score_factors USING btree (user_id);


--
-- Name: score_factors_uniquify_on_user_entry_klass; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX score_factors_uniquify_on_user_entry_klass ON score_factors USING btree (entry_id, klass, user_id);


--
-- Name: score_ordered_entries; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX score_ordered_entries ON entries USING btree (contest_id, disqualified, phase DESC, score DESC);


--
-- Name: search_addresses; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX search_addresses ON searched_strings USING btree (ip_address);


--
-- Name: search_terms; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX search_terms ON searched_strings USING btree (the_string);


--
-- Name: stage_plot_elements_stage_plot_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX stage_plot_elements_stage_plot_id ON stage_plot_elements USING btree (stage_plot_id);


--
-- Name: stage_plots_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX stage_plots_user_id ON stage_plots USING btree (user_id);


--
-- Name: supervisor_on_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX supervisor_on_user ON users USING btree ((((flags & (B'0100000000000000000000000000'::"bit")::integer) = (B'0100000000000000000000000000'::"bit")::integer)));


--
-- Name: taggings_taggable_type_and_taggable_id_context_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX taggings_taggable_type_and_taggable_id_context_idx ON taggings USING btree (taggable_type, taggable_id, context);


--
-- Name: tagocity; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX tagocity ON user_tags_old USING btree (user_id, item_type, item_id, tag_id);


--
-- Name: uniq_user_visits; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX uniq_user_visits ON site_visits USING btree (user_id, created_at);


--
-- Name: uniq_users; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX uniq_users ON users USING btree (user_name);


--
-- Name: unique_auto_completes; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_auto_completes ON completes USING btree (str, display_str, category);


--
-- Name: unique_bad_ip_addresses_address; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_bad_ip_addresses_address ON bad_ip_addresses USING btree (address);


--
-- Name: unique_battle_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_battle_index ON battles USING btree (user_id, entry_1_id, entry_2_id, battle_type, uniquifier);


--
-- Name: unique_block_asset_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_block_asset_key ON editable_block_assets USING btree (key);


--
-- Name: unique_calendar_name_per_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_calendar_name_per_user ON ourcal_calendars USING btree (user_id, name);


--
-- Name: unique_channel_and_start; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_channel_and_start ON contests USING btree (start_date, channel_id);


--
-- Name: unique_channel_views; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_channel_views ON channel_views USING btree (user_id, channel_id);


--
-- Name: unique_chat_room_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_chat_room_key ON live_chat_rooms USING btree (key);


--
-- Name: unique_embedded_player_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_embedded_player_key ON embedded_players USING btree (key);


--
-- Name: unique_entries_per_calendar; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_entries_per_calendar ON calendars_events USING btree (calendar_id, event_id);


--
-- Name: unique_entry_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_entry_key ON entries USING btree (key);


--
-- Name: unique_fans; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_fans ON fans USING btree (fan_club_id, user_id);


--
-- Name: unique_fast_battle_index_for_behaviors; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_fast_battle_index_for_behaviors ON battle_behavior_ratings USING btree (contest_id, behavior_class_name, user_id);


--
-- Name: unique_favorite_channels; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_favorite_channels ON favorite_channels USING btree (user_id, channel_id);


--
-- Name: unique_favorite_entries; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_favorite_entries ON favorite_entries USING btree (user_id, entry_id);


--
-- Name: unique_invite; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_invite ON invitations USING btree (user_id, invitee);


--
-- Name: unique_listing; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_listing ON message_blockers USING btree (user_id, blocked_id);


--
-- Name: unique_market_place_epk; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_market_place_epk ON market_place_epks USING btree (user_id);


--
-- Name: unique_media_item_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_media_item_key ON media_items USING btree (key);


--
-- Name: unique_page_block_tag; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_page_block_tag ON ej_page_blocks USING btree (tag);


--
-- Name: unique_partner_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_partner_name ON partners USING btree (name);


--
-- Name: unique_phase_keys_locales; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_phase_keys_locales ON translated_strings USING btree (key, locale);


--
-- Name: unique_prize_winner; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_prize_winner ON prize_winners USING btree (feature_item_id, entry_id);


--
-- Name: unique_profile; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_profile ON function_profiles USING btree (name, kind);


--
-- Name: unique_promotion_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_promotion_code ON promotions USING btree (code);


--
-- Name: unique_promotion_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_promotion_name ON promotions USING btree (name);


--
-- Name: unique_purchasable_inventory_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_purchasable_inventory_code ON purchasable_codes USING btree (ecommerce_inventory_item_id, code);


--
-- Name: unique_schedule_names; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schedule_names ON schedules USING btree (name);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: unique_subscription_plans_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_subscription_plans_title ON subscriptions_plans USING btree (title);


--
-- Name: unique_subscription_users_plan; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_subscription_users_plan ON subscriptions USING btree (user_id, plan_id);


--
-- Name: unique_tags; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_tags ON media_types USING btree (tag);


--
-- Name: unique_talent_player_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_talent_player_key ON games_talent_players USING btree (key);


--
-- Name: unique_talent_player_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_talent_player_user ON games_talent_players USING btree (user_id);


--
-- Name: unique_threads; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_threads ON listing_threads USING btree (listing_id, user_id);


--
-- Name: unique_users_external_uris_users_klasses; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_users_external_uris_users_klasses ON users_external_uris USING btree (user_id, klass);


--
-- Name: unique_users_friendships; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_users_friendships ON users_friendships USING btree (user_id, friend_id);


--
-- Name: user_for_period; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX user_for_period ON rev_share_records USING btree (user_id, period_id, subscription_id);


--
-- Name: user_last_ip_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_last_ip_index ON users USING btree (last_ip);


--
-- Name: user_lower_display_name_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_lower_display_name_idx ON users USING btree (lower((display_name)::text));


--
-- Name: user_playlists_by_playlist; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_playlists_by_playlist ON playlists_user_playlists USING btree (playlist_id);


--
-- Name: user_reg_ip_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX user_reg_ip_index ON users USING btree (reg_ip);


--
-- Name: user_roles_by_role_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX user_roles_by_role_id_and_user_id ON user_roles USING btree (role_id, user_id);


--
-- Name: user_roles_by_user_id_and_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX user_roles_by_user_id_and_role_id ON user_roles USING btree (user_id, role_id);


--
-- Name: users_by_activation_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_by_activation_code ON users USING btree (activation_code);


--
-- Name: users_by_promotion; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_by_promotion ON users USING btree (promotion_id);


--
-- Name: users_by_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_by_time ON users USING btree (created_at);


--
-- Name: users_full_vanity_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX users_full_vanity_index ON users USING btree (upper((vanity_uri_element)::text));


--
-- Name: users_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX users_id_idx ON users USING btree (id);


--
-- Name: users_latitude; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_latitude ON users USING btree (latitude);


--
-- Name: users_level_for_reports; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_level_for_reports ON users USING btree (user_level);


--
-- Name: users_longitude; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_longitude ON users USING btree (longitude);


--
-- Name: users_ourcal_events_by_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_ourcal_events_by_date ON ourcal_events USING btree (user_id, start_time);


--
-- Name: users_scored_battles_evar; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_scored_battles_evar ON battles USING btree (user_id, ((((scored_at IS NOT NULL) AND (function_profile_id <> 19)) AND ((parent_id IS NULL) OR (parent_id = id)))), contest_id);


--
-- Name: users_to_geolocate; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_to_geolocate ON users USING btree ((((flags & 128) = 0)));


--
-- Name: users_unique_email_addresses; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX users_unique_email_addresses ON users USING btree (email_address);


--
-- Name: users_uri_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX users_uri_index ON users USING btree (uri_element);


--
-- Name: users_vanity_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX users_vanity_index ON users USING btree (upper((vanity_uri_element)::text)) WHERE (vanity_uri_element IS NOT NULL);


--
-- Name: valid_comments_on_item_by_user_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX valid_comments_on_item_by_user_index ON comments USING btree (((flags & 1)), commentable_type, commentable_id, user_id);


--
-- Name: versioned_tag; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX versioned_tag ON editable_blocks USING btree (rvn, tag);


--
-- Name: word_press_posts_by_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX word_press_posts_by_time ON word_press_posts USING btree (created_at DESC);


--
-- Name: channel_score_entry; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY marketplace_channel_scores
    ADD CONSTRAINT channel_score_entry FOREIGN KEY (entry_id) REFERENCES entries(id);


--
-- Name: channel_score_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY marketplace_channel_scores
    ADD CONSTRAINT channel_score_user FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: filter_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY marketplace_filters
    ADD CONSTRAINT filter_user FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_actions_gigs; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY marketplace_gig_actions
    ADD CONSTRAINT fk_actions_gigs FOREIGN KEY (gig_id) REFERENCES marketplace_gigs(id);


--
-- Name: fk_activation_requests_to_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY activation_requests
    ADD CONSTRAINT fk_activation_requests_to_users FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_answer_questions; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY epk_answers
    ADD CONSTRAINT fk_answer_questions FOREIGN KEY (question_id) REFERENCES epk_questions(id);


--
-- Name: fk_artist_access_genres; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY artist_accesses
    ADD CONSTRAINT fk_artist_access_genres FOREIGN KEY (media_type_id) REFERENCES media_types(id);


--
-- Name: fk_artist_access_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY artist_accesses
    ADD CONSTRAINT fk_artist_access_item FOREIGN KEY (clip_id) REFERENCES media_items(id);


--
-- Name: fk_banner_entries; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY banner_hits
    ADD CONSTRAINT fk_banner_entries FOREIGN KEY (entry_id) REFERENCES entries(id);


--
-- Name: fk_battles_contests; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY battles
    ADD CONSTRAINT fk_battles_contests FOREIGN KEY (contest_id) REFERENCES contests(id);


--
-- Name: fk_battles_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY battles
    ADD CONSTRAINT fk_battles_users FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_block_rundown; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ej_page_blocks
    ADD CONSTRAINT fk_block_rundown FOREIGN KEY (ej_rundown_id) REFERENCES ej_rundowns(id);


--
-- Name: fk_blocked_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY message_blockers
    ADD CONSTRAINT fk_blocked_users FOREIGN KEY (blocked_id) REFERENCES users(id);


--
-- Name: fk_calendars_events_ourcal_calendars; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY calendars_events
    ADD CONSTRAINT fk_calendars_events_ourcal_calendars FOREIGN KEY (calendar_id) REFERENCES ourcal_calendars(id);


--
-- Name: fk_calendars_events_ourcal_events; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY calendars_events
    ADD CONSTRAINT fk_calendars_events_ourcal_events FOREIGN KEY (event_id) REFERENCES ourcal_events(id);


--
-- Name: fk_category_genres; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT fk_category_genres FOREIGN KEY (media_type_id) REFERENCES media_types(id);


--
-- Name: fk_channel_genres; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY channels
    ADD CONSTRAINT fk_channel_genres FOREIGN KEY (media_type_id) REFERENCES media_types(id);


--
-- Name: fk_channel_genres_channel; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY channel_genres
    ADD CONSTRAINT fk_channel_genres_channel FOREIGN KEY (channel_id) REFERENCES channels(id);


--
-- Name: fk_channel_genres_genre; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY channel_genres
    ADD CONSTRAINT fk_channel_genres_genre FOREIGN KEY (genre_id) REFERENCES classify_genres(id);


--
-- Name: fk_channel_media_market; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY channels
    ADD CONSTRAINT fk_channel_media_market FOREIGN KEY (upload_media_market_id) REFERENCES media_markets(id);


--
-- Name: fk_channel_region; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY channels
    ADD CONSTRAINT fk_channel_region FOREIGN KEY (upload_region_id) REFERENCES regions(id);


--
-- Name: fk_channel_views_channel; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY channel_views
    ADD CONSTRAINT fk_channel_views_channel FOREIGN KEY (channel_id) REFERENCES channels(id);


--
-- Name: fk_channel_views_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY channel_views
    ADD CONSTRAINT fk_channel_views_user FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_chart_channels; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY charts
    ADD CONSTRAINT fk_chart_channels FOREIGN KEY (channel_id) REFERENCES channels(id);


--
-- Name: fk_chart_item_charts; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chart_items
    ADD CONSTRAINT fk_chart_item_charts FOREIGN KEY (chart_id) REFERENCES charts(id);


--
-- Name: fk_chart_item_people; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chart_items
    ADD CONSTRAINT fk_chart_item_people FOREIGN KEY (person_id) REFERENCES users(id);


--
-- Name: fk_complaint_entries; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY complaints
    ADD CONSTRAINT fk_complaint_entries FOREIGN KEY (entry_id) REFERENCES entries(id);


--
-- Name: fk_complaint_media_items; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY complaints
    ADD CONSTRAINT fk_complaint_media_items FOREIGN KEY (media_item_id) REFERENCES media_items(id);


--
-- Name: fk_complaint_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY complaints
    ADD CONSTRAINT fk_complaint_users FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_contest_channels; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contests
    ADD CONSTRAINT fk_contest_channels FOREIGN KEY (channel_id) REFERENCES channels(id);


--
-- Name: fk_eb_playlist_items_eb_playlist; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY eb_playlist_items
    ADD CONSTRAINT fk_eb_playlist_items_eb_playlist FOREIGN KEY (eb_playlist_id) REFERENCES eb_playlists(id);


--
-- Name: fk_eb_playlist_items_editable_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY eb_playlist_items
    ADD CONSTRAINT fk_eb_playlist_items_editable_block FOREIGN KEY (editable_block_id) REFERENCES editable_blocks(id);


--
-- Name: fk_eb_playlist_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY eb_playlists
    ADD CONSTRAINT fk_eb_playlist_user FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_editable_block_asset_views_asset; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editable_block_asset_views
    ADD CONSTRAINT fk_editable_block_asset_views_asset FOREIGN KEY (editable_block_asset_id) REFERENCES editable_block_assets(id);


--
-- Name: fk_editable_block_assets_editable_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editable_block_assets
    ADD CONSTRAINT fk_editable_block_assets_editable_block FOREIGN KEY (editable_block_id) REFERENCES editable_blocks(id);


--
-- Name: fk_editorial_block_activation_tasks; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editorial_blocks
    ADD CONSTRAINT fk_editorial_block_activation_tasks FOREIGN KEY (activation_task_id) REFERENCES background_tasks(id);


--
-- Name: fk_editorial_item_channel_channel; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editorial_item_channels
    ADD CONSTRAINT fk_editorial_item_channel_channel FOREIGN KEY (channel_id) REFERENCES channels(id);


--
-- Name: fk_editorial_item_channel_feature_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editorial_item_channels
    ADD CONSTRAINT fk_editorial_item_channel_feature_item FOREIGN KEY (feature_item_id) REFERENCES feature_items(id);


--
-- Name: fk_editors; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY form_letters
    ADD CONSTRAINT fk_editors FOREIGN KEY (editor_id) REFERENCES users(id);


--
-- Name: fk_embedded_player_entry; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY embedded_players
    ADD CONSTRAINT fk_embedded_player_entry FOREIGN KEY (entry_id) REFERENCES entries(id);


--
-- Name: fk_embedded_player_genre; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY embedded_players
    ADD CONSTRAINT fk_embedded_player_genre FOREIGN KEY (media_type_id) REFERENCES media_types(id);


--
-- Name: fk_embedded_player_hit_player; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY embedded_player_hits
    ADD CONSTRAINT fk_embedded_player_hit_player FOREIGN KEY (embedded_player_id) REFERENCES embedded_players(id);


--
-- Name: fk_embedded_player_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY embedded_players
    ADD CONSTRAINT fk_embedded_player_user FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_entry_contests; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY entries
    ADD CONSTRAINT fk_entry_contests FOREIGN KEY (contest_id) REFERENCES contests(id);


--
-- Name: fk_entry_media_items; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY entries
    ADD CONSTRAINT fk_entry_media_items FOREIGN KEY (media_item_id) REFERENCES media_items(id);


--
-- Name: fk_entry_views_entry; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY entry_views
    ADD CONSTRAINT fk_entry_views_entry FOREIGN KEY (entry_id) REFERENCES entries(id);


--
-- Name: fk_entry_views_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY entry_views
    ADD CONSTRAINT fk_entry_views_user FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_envelope_letter; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY envelopes
    ADD CONSTRAINT fk_envelope_letter FOREIGN KEY (letter_id) REFERENCES letters(id);


--
-- Name: fk_envelope_recipients; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY envelopes
    ADD CONSTRAINT fk_envelope_recipients FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_fan_fan_clubs; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fans
    ADD CONSTRAINT fk_fan_fan_clubs FOREIGN KEY (fan_club_id) REFERENCES users(id);


--
-- Name: fk_fan_fans; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fans
    ADD CONSTRAINT fk_fan_fans FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_fave_channels_channels; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY favorite_channels
    ADD CONSTRAINT fk_fave_channels_channels FOREIGN KEY (channel_id) REFERENCES channels(id);


--
-- Name: fk_fave_channels_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY favorite_channels
    ADD CONSTRAINT fk_fave_channels_users FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_fave_entries_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY favorite_entries
    ADD CONSTRAINT fk_fave_entries_users FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_feature_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY feature_items
    ADD CONSTRAINT fk_feature_category FOREIGN KEY (category_id) REFERENCES feature_categories(id);


--
-- Name: fk_feature_genre; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY feature_items
    ADD CONSTRAINT fk_feature_genre FOREIGN KEY (media_type_id) REFERENCES media_types(id);


--
-- Name: fk_feature_image; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY feature_items
    ADD CONSTRAINT fk_feature_image FOREIGN KEY (image_id) REFERENCES feature_images(id);


--
-- Name: fk_feature_item_won; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY prize_winners
    ADD CONSTRAINT fk_feature_item_won FOREIGN KEY (feature_item_id) REFERENCES feature_items(id);


--
-- Name: fk_free_track_media_item_ids; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY free_tracks
    ADD CONSTRAINT fk_free_track_media_item_ids FOREIGN KEY (media_item_id) REFERENCES media_items(id);


--
-- Name: fk_friendship_friend; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_friendships
    ADD CONSTRAINT fk_friendship_friend FOREIGN KEY (friend_id) REFERENCES users(id);


--
-- Name: fk_friendship_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_friendships
    ADD CONSTRAINT fk_friendship_user FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_genre_final_channels; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_types
    ADD CONSTRAINT fk_genre_final_channels FOREIGN KEY (finals_channel_id) REFERENCES channels(id);


--
-- Name: fk_jango_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY jango_infos
    ADD CONSTRAINT fk_jango_users FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_letter_writers; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letters
    ADD CONSTRAINT fk_letter_writers FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_live_feed_item_genre; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY live_feed_items
    ADD CONSTRAINT fk_live_feed_item_genre FOREIGN KEY (media_type_id) REFERENCES media_types(id);


--
-- Name: fk_marketplace_applicants_artist; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY marketplace_applicants
    ADD CONSTRAINT fk_marketplace_applicants_artist FOREIGN KEY (artist_id) REFERENCES users(id);


--
-- Name: fk_marketplace_applicants_gig; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY marketplace_applicants
    ADD CONSTRAINT fk_marketplace_applicants_gig FOREIGN KEY (gig_id) REFERENCES marketplace_gigs(id);


--
-- Name: fk_marketplace_channels_gigs_channel; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY channels_gigs
    ADD CONSTRAINT fk_marketplace_channels_gigs_channel FOREIGN KEY (channel_id) REFERENCES channels(id);


--
-- Name: fk_marketplace_channels_gigs_gig; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY channels_gigs
    ADD CONSTRAINT fk_marketplace_channels_gigs_gig FOREIGN KEY (gig_id) REFERENCES marketplace_gigs(id);


--
-- Name: fk_marketplace_gigs_event; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY marketplace_gigs
    ADD CONSTRAINT fk_marketplace_gigs_event FOREIGN KEY (event_id) REFERENCES ourcal_events(id);


--
-- Name: fk_marketplace_gigs_venue; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY marketplace_gigs
    ADD CONSTRAINT fk_marketplace_gigs_venue FOREIGN KEY (venue_id) REFERENCES users(id);


--
-- Name: fk_marketplace_qualification_overrides_artist; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY marketplace_qualification_overrides
    ADD CONSTRAINT fk_marketplace_qualification_overrides_artist FOREIGN KEY (artist_id) REFERENCES users(id);


--
-- Name: fk_marketplace_qualification_overrides_gig; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY marketplace_qualification_overrides
    ADD CONSTRAINT fk_marketplace_qualification_overrides_gig FOREIGN KEY (gig_id) REFERENCES marketplace_gigs(id);


--
-- Name: fk_media_assets_image_owners; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_assets_images
    ADD CONSTRAINT fk_media_assets_image_owners FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_media_item_genres; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_items
    ADD CONSTRAINT fk_media_item_genres FOREIGN KEY (media_type_id) REFERENCES media_types(id);


--
-- Name: fk_media_item_views_media_item_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_item_views
    ADD CONSTRAINT fk_media_item_views_media_item_id FOREIGN KEY (media_item_id) REFERENCES media_items(id);


--
-- Name: fk_media_items_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_items
    ADD CONSTRAINT fk_media_items_users FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_media_market_zipcode_tv_media_market; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_market_zipcodes
    ADD CONSTRAINT fk_media_market_zipcode_tv_media_market FOREIGN KEY (media_market_id) REFERENCES media_markets(id);


--
-- Name: fk_message_blocker_owners; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY message_blockers
    ADD CONSTRAINT fk_message_blocker_owners FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_ourcal_events_our_locations; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ourcal_events
    ADD CONSTRAINT fk_ourcal_events_our_locations FOREIGN KEY (our_location_id) REFERENCES our_locations(id);


--
-- Name: fk_ourcal_events_posters; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ourcal_events
    ADD CONSTRAINT fk_ourcal_events_posters FOREIGN KEY (poster_id) REFERENCES media_assets_images(id);


--
-- Name: fk_player_playlist; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY playlists_to_players
    ADD CONSTRAINT fk_player_playlist FOREIGN KEY (playlist_id) REFERENCES playlists(id);


--
-- Name: fk_playlist_player; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY playlists_to_players
    ADD CONSTRAINT fk_playlist_player FOREIGN KEY (player_id) REFERENCES embedded_players(id);


--
-- Name: fk_playlists_genres; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY playlists
    ADD CONSTRAINT fk_playlists_genres FOREIGN KEY (media_type_id) REFERENCES media_types(id);


--
-- Name: fk_playlists_item_media_items; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY playlists_items
    ADD CONSTRAINT fk_playlists_item_media_items FOREIGN KEY (media_item_id) REFERENCES media_items(id);


--
-- Name: fk_playlists_item_playlists; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY playlists_items
    ADD CONSTRAINT fk_playlists_item_playlists FOREIGN KEY (playlist_id) REFERENCES playlists(id);


--
-- Name: fk_playlists_owners; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY playlists
    ADD CONSTRAINT fk_playlists_owners FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_post_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT fk_post_user FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_profile_link_profile; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_profile_links
    ADD CONSTRAINT fk_profile_link_profile FOREIGN KEY (profile_id) REFERENCES users_profiles(id);


--
-- Name: fk_profile_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_profiles
    ADD CONSTRAINT fk_profile_user FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_promo_download_authorizations_auth_promo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY promo_download_authorizations
    ADD CONSTRAINT fk_promo_download_authorizations_auth_promo FOREIGN KEY (promo_which_allows_access_id) REFERENCES promotions(id);


--
-- Name: fk_promo_download_authorizations_login_promo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY promo_download_authorizations
    ADD CONSTRAINT fk_promo_download_authorizations_login_promo FOREIGN KEY (promo_which_requires_login_id) REFERENCES promotions(id);


--
-- Name: fk_promotion_user_data_fields; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY promotion_user_data
    ADD CONSTRAINT fk_promotion_user_data_fields FOREIGN KEY (promotion_user_data_field_id) REFERENCES promotion_user_data_fields(id);


--
-- Name: fk_promotion_user_data_fields_promo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY promotion_user_data_fields
    ADD CONSTRAINT fk_promotion_user_data_fields_promo FOREIGN KEY (promotion_id) REFERENCES promotions(id);


--
-- Name: fk_promotion_user_data_fields_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY promotion_user_data
    ADD CONSTRAINT fk_promotion_user_data_fields_user FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_promotions_co_branding_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY promotions
    ADD CONSTRAINT fk_promotions_co_branding_id FOREIGN KEY (co_branding_id) REFERENCES co_brandings(id);


--
-- Name: fk_promotions_partners; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY promotions
    ADD CONSTRAINT fk_promotions_partners FOREIGN KEY (partner_id) REFERENCES partners(id);


--
-- Name: fk_reviewers; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY form_letters
    ADD CONSTRAINT fk_reviewers FOREIGN KEY (reviewer_id) REFERENCES users(id);


--
-- Name: fk_rundown_rundown; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ej_rundown_thangs
    ADD CONSTRAINT fk_rundown_rundown FOREIGN KEY (ej_rundown_id) REFERENCES ej_rundowns(id);


--
-- Name: fk_rundown_thangs; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ej_rundown_thangs
    ADD CONSTRAINT fk_rundown_thangs FOREIGN KEY (ej_thang_id) REFERENCES ej_thangs(id);


--
-- Name: fk_searched_strings_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY searched_strings
    ADD CONSTRAINT fk_searched_strings_user FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_senders; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY form_letters
    ADD CONSTRAINT fk_senders FOREIGN KEY (sender_id) REFERENCES users(id);


--
-- Name: fk_site_visit_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY site_visits
    ADD CONSTRAINT fk_site_visit_user FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_subscriptions_plans; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT fk_subscriptions_plans FOREIGN KEY (plan_id) REFERENCES subscriptions_plans(id);


--
-- Name: fk_subscriptions_purchased_songs_media_items; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions_purchased_songs
    ADD CONSTRAINT fk_subscriptions_purchased_songs_media_items FOREIGN KEY (media_item_id) REFERENCES media_items(id);


--
-- Name: fk_subscriptions_purchased_songs_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions_purchased_songs
    ADD CONSTRAINT fk_subscriptions_purchased_songs_users FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_subscriptions_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT fk_subscriptions_users FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_talent_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY games_talent_players
    ADD CONSTRAINT fk_talent_user FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_thang_media_item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ej_thangs
    ADD CONSTRAINT fk_thang_media_item FOREIGN KEY (media_item_id) REFERENCES media_items(id);


--
-- Name: fk_thang_title_image; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ej_thangs
    ADD CONSTRAINT fk_thang_title_image FOREIGN KEY (ej_title_image_id) REFERENCES ej_title_images(id);


--
-- Name: fk_upgradeable_subscriptions_plans; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions_plans
    ADD CONSTRAINT fk_upgradeable_subscriptions_plans FOREIGN KEY (upgradeable_to_id) REFERENCES subscriptions_plans(id);


--
-- Name: fk_user_info_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_infos
    ADD CONSTRAINT fk_user_info_user FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_user_playlist_playlists; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY playlists_user_playlists
    ADD CONSTRAINT fk_user_playlist_playlists FOREIGN KEY (playlist_id) REFERENCES playlists(id);


--
-- Name: fk_user_playlist_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY playlists_user_playlists
    ADD CONSTRAINT fk_user_playlist_users FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_user_uris; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_user_uris
    ADD CONSTRAINT fk_user_uris FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_users_block_about_me_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_about_mes
    ADD CONSTRAINT fk_users_block_about_me_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_achievement_list_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_achievement_lists
    ADD CONSTRAINT fk_users_block_achievement_list_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_artist_feed_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_artist_feeds
    ADD CONSTRAINT fk_users_block_artist_feed_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_blog_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_blogs
    ADD CONSTRAINT fk_users_block_blog_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_comment_list_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_comment_lists
    ADD CONSTRAINT fk_users_block_comment_list_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_data_event_calendars_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_event_calendars
    ADD CONSTRAINT fk_users_block_data_event_calendars_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_data_fc_memberships; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_fc_memberships
    ADD CONSTRAINT fk_users_block_data_fc_memberships FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_data_free_tracks; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_free_tracks
    ADD CONSTRAINT fk_users_block_data_free_tracks FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_data_photo_galleries; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_photo_galleries
    ADD CONSTRAINT fk_users_block_data_photo_galleries FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_fans_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_fan_lists
    ADD CONSTRAINT fk_users_block_fans_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_first_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_firsts
    ADD CONSTRAINT fk_users_block_first_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_friend_feed_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_friend_feeds
    ADD CONSTRAINT fk_users_block_friend_feed_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_friends_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_friend_lists
    ADD CONSTRAINT fk_users_block_friends_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_influence_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_influences
    ADD CONSTRAINT fk_users_block_influence_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_judge_history_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_judge_histories
    ADD CONSTRAINT fk_users_block_judge_history_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_link_box_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_link_boxes
    ADD CONSTRAINT fk_users_block_link_box_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_live_feed_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_live_feeds
    ADD CONSTRAINT fk_users_block_live_feed_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_media_items_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_media_item_lists
    ADD CONSTRAINT fk_users_block_media_items_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_music_faves_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_music_favorites
    ADD CONSTRAINT fk_users_block_music_faves_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_music_map_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_music_maps
    ADD CONSTRAINT fk_users_block_music_map_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_music_player_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_music_players
    ADD CONSTRAINT fk_users_block_music_player_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_my_account_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_my_accounts
    ADD CONSTRAINT fk_users_block_my_account_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_stage_spec_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_stage_specs
    ADD CONSTRAINT fk_users_block_stage_spec_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_venue_info_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_venue_infos
    ADD CONSTRAINT fk_users_block_venue_info_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_video_faves_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_video_favorites
    ADD CONSTRAINT fk_users_block_video_faves_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_block_video_player_block; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_block_data_video_players
    ADD CONSTRAINT fk_users_block_video_player_block FOREIGN KEY (block_id) REFERENCES users_profile_blocks(id);


--
-- Name: fk_users_demographics_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_demographics
    ADD CONSTRAINT fk_users_demographics_users FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_users_external_uris_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_external_uris
    ADD CONSTRAINT fk_users_external_uris_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_users_gallery_owners; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_photo_galleries
    ADD CONSTRAINT fk_users_gallery_owners FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_users_ourcal_calendars; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ourcal_calendars
    ADD CONSTRAINT fk_users_ourcal_calendars FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_users_ourcal_events; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ourcal_events
    ADD CONSTRAINT fk_users_ourcal_events FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_users_photo_gallery_item_galleries; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_photo_gallery_items
    ADD CONSTRAINT fk_users_photo_gallery_item_galleries FOREIGN KEY (users_photo_gallery_id) REFERENCES users_photo_galleries(id);


--
-- Name: fk_users_photo_gallery_item_images; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_photo_gallery_items
    ADD CONSTRAINT fk_users_photo_gallery_item_images FOREIGN KEY (media_assets_image_id) REFERENCES media_assets_images(id);


--
-- Name: fk_winning_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY prize_winners
    ADD CONSTRAINT fk_winning_user FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_word_press_categories_word_press_post_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY word_press_categories
    ADD CONSTRAINT fk_word_press_categories_word_press_post_id FOREIGN KEY (word_press_post_id) REFERENCES word_press_posts(id);


--
-- Name: fk_word_press_tags_word_press_post_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY word_press_tags
    ADD CONSTRAINT fk_word_press_tags_word_press_post_id FOREIGN KEY (word_press_post_id) REFERENCES word_press_posts(id);


--
-- Name: fk_word_word_press_posts_press_author_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY word_press_posts
    ADD CONSTRAINT fk_word_word_press_posts_press_author_id FOREIGN KEY (word_press_author_id) REFERENCES word_press_authors(id);


--
-- Name: giveaways_creator; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY giveaways
    ADD CONSTRAINT giveaways_creator FOREIGN KEY (creator_id) REFERENCES users(id);


--
-- Name: giveaways_image_1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY giveaways
    ADD CONSTRAINT giveaways_image_1 FOREIGN KEY (image_1_id) REFERENCES media_assets_images(id);


--
-- Name: giveaways_image_2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY giveaways
    ADD CONSTRAINT giveaways_image_2 FOREIGN KEY (image_2_id) REFERENCES media_assets_images(id);


--
-- Name: live_chat_room_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY live_chat_rooms
    ADD CONSTRAINT live_chat_room_users FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: live_user_state; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY live_user_states
    ADD CONSTRAINT live_user_state FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('10');

INSERT INTO schema_migrations (version) VALUES ('100');

INSERT INTO schema_migrations (version) VALUES ('101');

INSERT INTO schema_migrations (version) VALUES ('102');

INSERT INTO schema_migrations (version) VALUES ('103');

INSERT INTO schema_migrations (version) VALUES ('104');

INSERT INTO schema_migrations (version) VALUES ('105');

INSERT INTO schema_migrations (version) VALUES ('106');

INSERT INTO schema_migrations (version) VALUES ('107');

INSERT INTO schema_migrations (version) VALUES ('108');

INSERT INTO schema_migrations (version) VALUES ('109');

INSERT INTO schema_migrations (version) VALUES ('11');

INSERT INTO schema_migrations (version) VALUES ('110');

INSERT INTO schema_migrations (version) VALUES ('111');

INSERT INTO schema_migrations (version) VALUES ('112');

INSERT INTO schema_migrations (version) VALUES ('113');

INSERT INTO schema_migrations (version) VALUES ('114');

INSERT INTO schema_migrations (version) VALUES ('115');

INSERT INTO schema_migrations (version) VALUES ('116');

INSERT INTO schema_migrations (version) VALUES ('117');

INSERT INTO schema_migrations (version) VALUES ('118');

INSERT INTO schema_migrations (version) VALUES ('119');

INSERT INTO schema_migrations (version) VALUES ('12');

INSERT INTO schema_migrations (version) VALUES ('120');

INSERT INTO schema_migrations (version) VALUES ('121');

INSERT INTO schema_migrations (version) VALUES ('122');

INSERT INTO schema_migrations (version) VALUES ('123');

INSERT INTO schema_migrations (version) VALUES ('124');

INSERT INTO schema_migrations (version) VALUES ('125');

INSERT INTO schema_migrations (version) VALUES ('126');

INSERT INTO schema_migrations (version) VALUES ('127');

INSERT INTO schema_migrations (version) VALUES ('128');

INSERT INTO schema_migrations (version) VALUES ('129');

INSERT INTO schema_migrations (version) VALUES ('13');

INSERT INTO schema_migrations (version) VALUES ('130');

INSERT INTO schema_migrations (version) VALUES ('131');

INSERT INTO schema_migrations (version) VALUES ('132');

INSERT INTO schema_migrations (version) VALUES ('133');

INSERT INTO schema_migrations (version) VALUES ('134');

INSERT INTO schema_migrations (version) VALUES ('135');

INSERT INTO schema_migrations (version) VALUES ('136');

INSERT INTO schema_migrations (version) VALUES ('137');

INSERT INTO schema_migrations (version) VALUES ('138');

INSERT INTO schema_migrations (version) VALUES ('139');

INSERT INTO schema_migrations (version) VALUES ('14');

INSERT INTO schema_migrations (version) VALUES ('140');

INSERT INTO schema_migrations (version) VALUES ('141');

INSERT INTO schema_migrations (version) VALUES ('142');

INSERT INTO schema_migrations (version) VALUES ('143');

INSERT INTO schema_migrations (version) VALUES ('144');

INSERT INTO schema_migrations (version) VALUES ('145');

INSERT INTO schema_migrations (version) VALUES ('146');

INSERT INTO schema_migrations (version) VALUES ('147');

INSERT INTO schema_migrations (version) VALUES ('148');

INSERT INTO schema_migrations (version) VALUES ('149');

INSERT INTO schema_migrations (version) VALUES ('15');

INSERT INTO schema_migrations (version) VALUES ('150');

INSERT INTO schema_migrations (version) VALUES ('151');

INSERT INTO schema_migrations (version) VALUES ('152');

INSERT INTO schema_migrations (version) VALUES ('153');

INSERT INTO schema_migrations (version) VALUES ('154');

INSERT INTO schema_migrations (version) VALUES ('155');

INSERT INTO schema_migrations (version) VALUES ('156');

INSERT INTO schema_migrations (version) VALUES ('157');

INSERT INTO schema_migrations (version) VALUES ('158');

INSERT INTO schema_migrations (version) VALUES ('159');

INSERT INTO schema_migrations (version) VALUES ('16');

INSERT INTO schema_migrations (version) VALUES ('160');

INSERT INTO schema_migrations (version) VALUES ('161');

INSERT INTO schema_migrations (version) VALUES ('162');

INSERT INTO schema_migrations (version) VALUES ('163');

INSERT INTO schema_migrations (version) VALUES ('164');

INSERT INTO schema_migrations (version) VALUES ('165');

INSERT INTO schema_migrations (version) VALUES ('166');

INSERT INTO schema_migrations (version) VALUES ('167');

INSERT INTO schema_migrations (version) VALUES ('168');

INSERT INTO schema_migrations (version) VALUES ('169');

INSERT INTO schema_migrations (version) VALUES ('17');

INSERT INTO schema_migrations (version) VALUES ('170');

INSERT INTO schema_migrations (version) VALUES ('171');

INSERT INTO schema_migrations (version) VALUES ('172');

INSERT INTO schema_migrations (version) VALUES ('173');

INSERT INTO schema_migrations (version) VALUES ('174');

INSERT INTO schema_migrations (version) VALUES ('175');

INSERT INTO schema_migrations (version) VALUES ('176');

INSERT INTO schema_migrations (version) VALUES ('177');

INSERT INTO schema_migrations (version) VALUES ('178');

INSERT INTO schema_migrations (version) VALUES ('179');

INSERT INTO schema_migrations (version) VALUES ('18');

INSERT INTO schema_migrations (version) VALUES ('180');

INSERT INTO schema_migrations (version) VALUES ('181');

INSERT INTO schema_migrations (version) VALUES ('182');

INSERT INTO schema_migrations (version) VALUES ('183');

INSERT INTO schema_migrations (version) VALUES ('184');

INSERT INTO schema_migrations (version) VALUES ('185');

INSERT INTO schema_migrations (version) VALUES ('186');

INSERT INTO schema_migrations (version) VALUES ('187');

INSERT INTO schema_migrations (version) VALUES ('188');

INSERT INTO schema_migrations (version) VALUES ('189');

INSERT INTO schema_migrations (version) VALUES ('19');

INSERT INTO schema_migrations (version) VALUES ('190');

INSERT INTO schema_migrations (version) VALUES ('191');

INSERT INTO schema_migrations (version) VALUES ('192');

INSERT INTO schema_migrations (version) VALUES ('193');

INSERT INTO schema_migrations (version) VALUES ('194');

INSERT INTO schema_migrations (version) VALUES ('195');

INSERT INTO schema_migrations (version) VALUES ('196');

INSERT INTO schema_migrations (version) VALUES ('197');

INSERT INTO schema_migrations (version) VALUES ('198');

INSERT INTO schema_migrations (version) VALUES ('199');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20');

INSERT INTO schema_migrations (version) VALUES ('200');

INSERT INTO schema_migrations (version) VALUES ('20081007172243');

INSERT INTO schema_migrations (version) VALUES ('20081007192559');

INSERT INTO schema_migrations (version) VALUES ('20081017050000');

INSERT INTO schema_migrations (version) VALUES ('20081022131805');

INSERT INTO schema_migrations (version) VALUES ('20081024131406');

INSERT INTO schema_migrations (version) VALUES ('20081027145923');

INSERT INTO schema_migrations (version) VALUES ('20081027150955');

INSERT INTO schema_migrations (version) VALUES ('20081031194057');

INSERT INTO schema_migrations (version) VALUES ('20081107164510');

INSERT INTO schema_migrations (version) VALUES ('20081114203510');

INSERT INTO schema_migrations (version) VALUES ('20081117212821');

INSERT INTO schema_migrations (version) VALUES ('20081120153942');

INSERT INTO schema_migrations (version) VALUES ('20081121185254');

INSERT INTO schema_migrations (version) VALUES ('20081122115947');

INSERT INTO schema_migrations (version) VALUES ('20081218205303');

INSERT INTO schema_migrations (version) VALUES ('20090206224835');

INSERT INTO schema_migrations (version) VALUES ('20090219142534');

INSERT INTO schema_migrations (version) VALUES ('20090220221854');

INSERT INTO schema_migrations (version) VALUES ('20090225174626');

INSERT INTO schema_migrations (version) VALUES ('20090227121554');

INSERT INTO schema_migrations (version) VALUES ('20090304135057');

INSERT INTO schema_migrations (version) VALUES ('20090309135430');

INSERT INTO schema_migrations (version) VALUES ('20090313174804');

INSERT INTO schema_migrations (version) VALUES ('20090326165936');

INSERT INTO schema_migrations (version) VALUES ('20090331161001');

INSERT INTO schema_migrations (version) VALUES ('20090331180228');

INSERT INTO schema_migrations (version) VALUES ('20090401214845');

INSERT INTO schema_migrations (version) VALUES ('20090403150939');

INSERT INTO schema_migrations (version) VALUES ('20090403152331');

INSERT INTO schema_migrations (version) VALUES ('20090406155719');

INSERT INTO schema_migrations (version) VALUES ('20090406192618');

INSERT INTO schema_migrations (version) VALUES ('20090413152831');

INSERT INTO schema_migrations (version) VALUES ('20090413183945');

INSERT INTO schema_migrations (version) VALUES ('20090417140739');

INSERT INTO schema_migrations (version) VALUES ('20090505140559');

INSERT INTO schema_migrations (version) VALUES ('20090508144531');

INSERT INTO schema_migrations (version) VALUES ('20090509201739');

INSERT INTO schema_migrations (version) VALUES ('20090512143306');

INSERT INTO schema_migrations (version) VALUES ('20090512184342');

INSERT INTO schema_migrations (version) VALUES ('20090527185550');

INSERT INTO schema_migrations (version) VALUES ('20090601214215');

INSERT INTO schema_migrations (version) VALUES ('20090604010342');

INSERT INTO schema_migrations (version) VALUES ('20090609181134');

INSERT INTO schema_migrations (version) VALUES ('20090611150234');

INSERT INTO schema_migrations (version) VALUES ('20090611182622');

INSERT INTO schema_migrations (version) VALUES ('20090630133344');

INSERT INTO schema_migrations (version) VALUES ('20090701175343');

INSERT INTO schema_migrations (version) VALUES ('20090723113954');

INSERT INTO schema_migrations (version) VALUES ('20090727172727');

INSERT INTO schema_migrations (version) VALUES ('20090728134023');

INSERT INTO schema_migrations (version) VALUES ('20090729180438');

INSERT INTO schema_migrations (version) VALUES ('20090811171339');

INSERT INTO schema_migrations (version) VALUES ('20090814180110');

INSERT INTO schema_migrations (version) VALUES ('20090819190712');

INSERT INTO schema_migrations (version) VALUES ('20091001211515');

INSERT INTO schema_migrations (version) VALUES ('20091008134911');

INSERT INTO schema_migrations (version) VALUES ('20091014141351');

INSERT INTO schema_migrations (version) VALUES ('20091016171658');

INSERT INTO schema_migrations (version) VALUES ('20091020152331');

INSERT INTO schema_migrations (version) VALUES ('20091021153550');

INSERT INTO schema_migrations (version) VALUES ('20091103201338');

INSERT INTO schema_migrations (version) VALUES ('20091112153013');

INSERT INTO schema_migrations (version) VALUES ('20091116134222');

INSERT INTO schema_migrations (version) VALUES ('20091117202409');

INSERT INTO schema_migrations (version) VALUES ('20091201162735');

INSERT INTO schema_migrations (version) VALUES ('20091201162757');

INSERT INTO schema_migrations (version) VALUES ('20091203162222');

INSERT INTO schema_migrations (version) VALUES ('20091203214417');

INSERT INTO schema_migrations (version) VALUES ('20091204204402');

INSERT INTO schema_migrations (version) VALUES ('20091210203632');

INSERT INTO schema_migrations (version) VALUES ('201');

INSERT INTO schema_migrations (version) VALUES ('20100104160429');

INSERT INTO schema_migrations (version) VALUES ('20100113171646');

INSERT INTO schema_migrations (version) VALUES ('20100114172727');

INSERT INTO schema_migrations (version) VALUES ('20100120014130');

INSERT INTO schema_migrations (version) VALUES ('20100125202151');

INSERT INTO schema_migrations (version) VALUES ('20100126160654');

INSERT INTO schema_migrations (version) VALUES ('20100126204227');

INSERT INTO schema_migrations (version) VALUES ('20100128025104');

INSERT INTO schema_migrations (version) VALUES ('20100204155821');

INSERT INTO schema_migrations (version) VALUES ('20100204195313');

INSERT INTO schema_migrations (version) VALUES ('20100208202126');

INSERT INTO schema_migrations (version) VALUES ('20100208202818');

INSERT INTO schema_migrations (version) VALUES ('20100210172634');

INSERT INTO schema_migrations (version) VALUES ('20100211153119');

INSERT INTO schema_migrations (version) VALUES ('20100212143604');

INSERT INTO schema_migrations (version) VALUES ('20100220054637');

INSERT INTO schema_migrations (version) VALUES ('20100222180953');

INSERT INTO schema_migrations (version) VALUES ('20100222202430');

INSERT INTO schema_migrations (version) VALUES ('20100225213938');

INSERT INTO schema_migrations (version) VALUES ('20100226152242');

INSERT INTO schema_migrations (version) VALUES ('20100227211136');

INSERT INTO schema_migrations (version) VALUES ('20100303205810');

INSERT INTO schema_migrations (version) VALUES ('20100308155511');

INSERT INTO schema_migrations (version) VALUES ('20100310182418');

INSERT INTO schema_migrations (version) VALUES ('20100311155108');

INSERT INTO schema_migrations (version) VALUES ('20100316202211');

INSERT INTO schema_migrations (version) VALUES ('20100323125549');

INSERT INTO schema_migrations (version) VALUES ('20100325192324');

INSERT INTO schema_migrations (version) VALUES ('20100331163505');

INSERT INTO schema_migrations (version) VALUES ('20100401200016');

INSERT INTO schema_migrations (version) VALUES ('20100406152108');

INSERT INTO schema_migrations (version) VALUES ('20100406184505');

INSERT INTO schema_migrations (version) VALUES ('20100407143759');

INSERT INTO schema_migrations (version) VALUES ('20100415130637');

INSERT INTO schema_migrations (version) VALUES ('20100419175246');

INSERT INTO schema_migrations (version) VALUES ('20100427203336');

INSERT INTO schema_migrations (version) VALUES ('20100429190119');

INSERT INTO schema_migrations (version) VALUES ('20100503203251');

INSERT INTO schema_migrations (version) VALUES ('20100504195620');

INSERT INTO schema_migrations (version) VALUES ('20100505132618');

INSERT INTO schema_migrations (version) VALUES ('20100506173333');

INSERT INTO schema_migrations (version) VALUES ('20100512181720');

INSERT INTO schema_migrations (version) VALUES ('20100518193750');

INSERT INTO schema_migrations (version) VALUES ('20100519192803');

INSERT INTO schema_migrations (version) VALUES ('20100520203235');

INSERT INTO schema_migrations (version) VALUES ('20100526140943');

INSERT INTO schema_migrations (version) VALUES ('20100526180424');

INSERT INTO schema_migrations (version) VALUES ('20100527180952');

INSERT INTO schema_migrations (version) VALUES ('20100528142445');

INSERT INTO schema_migrations (version) VALUES ('20100528163036');

INSERT INTO schema_migrations (version) VALUES ('20100601131117');

INSERT INTO schema_migrations (version) VALUES ('20100602145932');

INSERT INTO schema_migrations (version) VALUES ('20100602164956');

INSERT INTO schema_migrations (version) VALUES ('20100603133103');

INSERT INTO schema_migrations (version) VALUES ('20100604030130');

INSERT INTO schema_migrations (version) VALUES ('20100609181856');

INSERT INTO schema_migrations (version) VALUES ('20100611205055');

INSERT INTO schema_migrations (version) VALUES ('20100617194808');

INSERT INTO schema_migrations (version) VALUES ('20100622132726');

INSERT INTO schema_migrations (version) VALUES ('20100628181152');

INSERT INTO schema_migrations (version) VALUES ('20100629143213');

INSERT INTO schema_migrations (version) VALUES ('20100630202051');

INSERT INTO schema_migrations (version) VALUES ('20100706182305');

INSERT INTO schema_migrations (version) VALUES ('20100714152308');

INSERT INTO schema_migrations (version) VALUES ('20100722143647');

INSERT INTO schema_migrations (version) VALUES ('20100722154429');

INSERT INTO schema_migrations (version) VALUES ('20100727164836');

INSERT INTO schema_migrations (version) VALUES ('20100803200332');

INSERT INTO schema_migrations (version) VALUES ('20100811135854');

INSERT INTO schema_migrations (version) VALUES ('20100811144139');

INSERT INTO schema_migrations (version) VALUES ('20100813145331');

INSERT INTO schema_migrations (version) VALUES ('20100819131225');

INSERT INTO schema_migrations (version) VALUES ('20100819170859');

INSERT INTO schema_migrations (version) VALUES ('20100820210820');

INSERT INTO schema_migrations (version) VALUES ('20100823194039');

INSERT INTO schema_migrations (version) VALUES ('20100823210633');

INSERT INTO schema_migrations (version) VALUES ('20100824144013');

INSERT INTO schema_migrations (version) VALUES ('20100827144740');

INSERT INTO schema_migrations (version) VALUES ('20100830135157');

INSERT INTO schema_migrations (version) VALUES ('20100831202231');

INSERT INTO schema_migrations (version) VALUES ('20100907140338');

INSERT INTO schema_migrations (version) VALUES ('20100914144342');

INSERT INTO schema_migrations (version) VALUES ('20100915171118');

INSERT INTO schema_migrations (version) VALUES ('20100916180740');

INSERT INTO schema_migrations (version) VALUES ('20100920153253');

INSERT INTO schema_migrations (version) VALUES ('20100921151542');

INSERT INTO schema_migrations (version) VALUES ('20100921201004');

INSERT INTO schema_migrations (version) VALUES ('20100922131459');

INSERT INTO schema_migrations (version) VALUES ('20100922165330');

INSERT INTO schema_migrations (version) VALUES ('20100923141601');

INSERT INTO schema_migrations (version) VALUES ('20100923154304');

INSERT INTO schema_migrations (version) VALUES ('20100927175646');

INSERT INTO schema_migrations (version) VALUES ('20100927180528');

INSERT INTO schema_migrations (version) VALUES ('20101001191909');

INSERT INTO schema_migrations (version) VALUES ('20101006184253');

INSERT INTO schema_migrations (version) VALUES ('20101007133512');

INSERT INTO schema_migrations (version) VALUES ('20101007192817');

INSERT INTO schema_migrations (version) VALUES ('20101011165009');

INSERT INTO schema_migrations (version) VALUES ('20101014135253');

INSERT INTO schema_migrations (version) VALUES ('20101020133408');

INSERT INTO schema_migrations (version) VALUES ('20101022142501');

INSERT INTO schema_migrations (version) VALUES ('20101025173802');

INSERT INTO schema_migrations (version) VALUES ('20101028153848');

INSERT INTO schema_migrations (version) VALUES ('20101116205722');

INSERT INTO schema_migrations (version) VALUES ('20101117185750');

INSERT INTO schema_migrations (version) VALUES ('20101208195907');

INSERT INTO schema_migrations (version) VALUES ('20101209153514');

INSERT INTO schema_migrations (version) VALUES ('20101217175022');

INSERT INTO schema_migrations (version) VALUES ('20101223143003');

INSERT INTO schema_migrations (version) VALUES ('20110105212030');

INSERT INTO schema_migrations (version) VALUES ('20110107225157');

INSERT INTO schema_migrations (version) VALUES ('20110110150238');

INSERT INTO schema_migrations (version) VALUES ('20110110201636');

INSERT INTO schema_migrations (version) VALUES ('20110121193021');

INSERT INTO schema_migrations (version) VALUES ('20110124225537');

INSERT INTO schema_migrations (version) VALUES ('20110125003115');

INSERT INTO schema_migrations (version) VALUES ('20110203141018');

INSERT INTO schema_migrations (version) VALUES ('20110214173828');

INSERT INTO schema_migrations (version) VALUES ('20110214212407');

INSERT INTO schema_migrations (version) VALUES ('20110218163529');

INSERT INTO schema_migrations (version) VALUES ('20110224195139');

INSERT INTO schema_migrations (version) VALUES ('20110225213853');

INSERT INTO schema_migrations (version) VALUES ('20110228222002');

INSERT INTO schema_migrations (version) VALUES ('20110303184134');

INSERT INTO schema_migrations (version) VALUES ('20110307204615');

INSERT INTO schema_migrations (version) VALUES ('20110317193259');

INSERT INTO schema_migrations (version) VALUES ('20110322183716');

INSERT INTO schema_migrations (version) VALUES ('20110328175937');

INSERT INTO schema_migrations (version) VALUES ('20110328191723');

INSERT INTO schema_migrations (version) VALUES ('20110404195857');

INSERT INTO schema_migrations (version) VALUES ('20110418141429');

INSERT INTO schema_migrations (version) VALUES ('20110419191547');

INSERT INTO schema_migrations (version) VALUES ('20110420194112');

INSERT INTO schema_migrations (version) VALUES ('20110427150404');

INSERT INTO schema_migrations (version) VALUES ('20110518201251');

INSERT INTO schema_migrations (version) VALUES ('20110519140343');

INSERT INTO schema_migrations (version) VALUES ('20110621201112');

INSERT INTO schema_migrations (version) VALUES ('20110622210528');

INSERT INTO schema_migrations (version) VALUES ('20110623142702');

INSERT INTO schema_migrations (version) VALUES ('20110628183555');

INSERT INTO schema_migrations (version) VALUES ('20110707155310');

INSERT INTO schema_migrations (version) VALUES ('20110707170849');

INSERT INTO schema_migrations (version) VALUES ('20110714144927');

INSERT INTO schema_migrations (version) VALUES ('20110720192802');

INSERT INTO schema_migrations (version) VALUES ('20110803125018');

INSERT INTO schema_migrations (version) VALUES ('20110815135352');

INSERT INTO schema_migrations (version) VALUES ('20110818141715');

INSERT INTO schema_migrations (version) VALUES ('20110823174528');

INSERT INTO schema_migrations (version) VALUES ('20110831144305');

INSERT INTO schema_migrations (version) VALUES ('20110902145429');

INSERT INTO schema_migrations (version) VALUES ('20110912175618');

INSERT INTO schema_migrations (version) VALUES ('20110916143532');

INSERT INTO schema_migrations (version) VALUES ('20110927133629');

INSERT INTO schema_migrations (version) VALUES ('20111003210523');

INSERT INTO schema_migrations (version) VALUES ('20111020135128');

INSERT INTO schema_migrations (version) VALUES ('20111111175704');

INSERT INTO schema_migrations (version) VALUES ('20111122183109');

INSERT INTO schema_migrations (version) VALUES ('20111123152107');

INSERT INTO schema_migrations (version) VALUES ('20111124032658');

INSERT INTO schema_migrations (version) VALUES ('20111124032659');

INSERT INTO schema_migrations (version) VALUES ('20111216192432');

INSERT INTO schema_migrations (version) VALUES ('20120105134454');

INSERT INTO schema_migrations (version) VALUES ('20120105141737');

INSERT INTO schema_migrations (version) VALUES ('20120116141117');

INSERT INTO schema_migrations (version) VALUES ('20120116203053');

INSERT INTO schema_migrations (version) VALUES ('20120117161203');

INSERT INTO schema_migrations (version) VALUES ('20120118134547');

INSERT INTO schema_migrations (version) VALUES ('20120126142543');

INSERT INTO schema_migrations (version) VALUES ('20120126183016');

INSERT INTO schema_migrations (version) VALUES ('20120130153240');

INSERT INTO schema_migrations (version) VALUES ('20120131210024');

INSERT INTO schema_migrations (version) VALUES ('20120201143715');

INSERT INTO schema_migrations (version) VALUES ('20120201172702');

INSERT INTO schema_migrations (version) VALUES ('20120208160436');

INSERT INTO schema_migrations (version) VALUES ('20120214160436');

INSERT INTO schema_migrations (version) VALUES ('20120222152505');

INSERT INTO schema_migrations (version) VALUES ('20120223202252');

INSERT INTO schema_migrations (version) VALUES ('20120229151827');

INSERT INTO schema_migrations (version) VALUES ('20120229200711');

INSERT INTO schema_migrations (version) VALUES ('20120301194946');

INSERT INTO schema_migrations (version) VALUES ('20120304023050');

INSERT INTO schema_migrations (version) VALUES ('20120308162200');

INSERT INTO schema_migrations (version) VALUES ('20120317052331');

INSERT INTO schema_migrations (version) VALUES ('20120319195052');

INSERT INTO schema_migrations (version) VALUES ('20120320182004');

INSERT INTO schema_migrations (version) VALUES ('20120323174939');

INSERT INTO schema_migrations (version) VALUES ('20120328200358');

INSERT INTO schema_migrations (version) VALUES ('20120402153522');

INSERT INTO schema_migrations (version) VALUES ('20120516192903');

INSERT INTO schema_migrations (version) VALUES ('20120517182408');

INSERT INTO schema_migrations (version) VALUES ('20120523133600');

INSERT INTO schema_migrations (version) VALUES ('20120523145814');

INSERT INTO schema_migrations (version) VALUES ('20120523150507');

INSERT INTO schema_migrations (version) VALUES ('20120531172704');

INSERT INTO schema_migrations (version) VALUES ('20120601001657');

INSERT INTO schema_migrations (version) VALUES ('20120605153628');

INSERT INTO schema_migrations (version) VALUES ('20120608150706');

INSERT INTO schema_migrations (version) VALUES ('20120611155113');

INSERT INTO schema_migrations (version) VALUES ('20120614150532');

INSERT INTO schema_migrations (version) VALUES ('20120619200752');

INSERT INTO schema_migrations (version) VALUES ('20120621160241');

INSERT INTO schema_migrations (version) VALUES ('20120705175411');

INSERT INTO schema_migrations (version) VALUES ('20120710165655');

INSERT INTO schema_migrations (version) VALUES ('20120712184406');

INSERT INTO schema_migrations (version) VALUES ('20120713141400');

INSERT INTO schema_migrations (version) VALUES ('202');

INSERT INTO schema_migrations (version) VALUES ('203');

INSERT INTO schema_migrations (version) VALUES ('204');

INSERT INTO schema_migrations (version) VALUES ('205');

INSERT INTO schema_migrations (version) VALUES ('206');

INSERT INTO schema_migrations (version) VALUES ('207');

INSERT INTO schema_migrations (version) VALUES ('208');

INSERT INTO schema_migrations (version) VALUES ('209');

INSERT INTO schema_migrations (version) VALUES ('21');

INSERT INTO schema_migrations (version) VALUES ('210');

INSERT INTO schema_migrations (version) VALUES ('211');

INSERT INTO schema_migrations (version) VALUES ('212');

INSERT INTO schema_migrations (version) VALUES ('213');

INSERT INTO schema_migrations (version) VALUES ('214');

INSERT INTO schema_migrations (version) VALUES ('215');

INSERT INTO schema_migrations (version) VALUES ('216');

INSERT INTO schema_migrations (version) VALUES ('217');

INSERT INTO schema_migrations (version) VALUES ('218');

INSERT INTO schema_migrations (version) VALUES ('219');

INSERT INTO schema_migrations (version) VALUES ('22');

INSERT INTO schema_migrations (version) VALUES ('220');

INSERT INTO schema_migrations (version) VALUES ('221');

INSERT INTO schema_migrations (version) VALUES ('222');

INSERT INTO schema_migrations (version) VALUES ('223');

INSERT INTO schema_migrations (version) VALUES ('224');

INSERT INTO schema_migrations (version) VALUES ('225');

INSERT INTO schema_migrations (version) VALUES ('23');

INSERT INTO schema_migrations (version) VALUES ('24');

INSERT INTO schema_migrations (version) VALUES ('25');

INSERT INTO schema_migrations (version) VALUES ('26');

INSERT INTO schema_migrations (version) VALUES ('27');

INSERT INTO schema_migrations (version) VALUES ('28');

INSERT INTO schema_migrations (version) VALUES ('29');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('30');

INSERT INTO schema_migrations (version) VALUES ('31');

INSERT INTO schema_migrations (version) VALUES ('32');

INSERT INTO schema_migrations (version) VALUES ('33');

INSERT INTO schema_migrations (version) VALUES ('34');

INSERT INTO schema_migrations (version) VALUES ('35');

INSERT INTO schema_migrations (version) VALUES ('36');

INSERT INTO schema_migrations (version) VALUES ('37');

INSERT INTO schema_migrations (version) VALUES ('38');

INSERT INTO schema_migrations (version) VALUES ('39');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('40');

INSERT INTO schema_migrations (version) VALUES ('41');

INSERT INTO schema_migrations (version) VALUES ('42');

INSERT INTO schema_migrations (version) VALUES ('43');

INSERT INTO schema_migrations (version) VALUES ('44');

INSERT INTO schema_migrations (version) VALUES ('45');

INSERT INTO schema_migrations (version) VALUES ('46');

INSERT INTO schema_migrations (version) VALUES ('47');

INSERT INTO schema_migrations (version) VALUES ('48');

INSERT INTO schema_migrations (version) VALUES ('49');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('50');

INSERT INTO schema_migrations (version) VALUES ('51');

INSERT INTO schema_migrations (version) VALUES ('52');

INSERT INTO schema_migrations (version) VALUES ('53');

INSERT INTO schema_migrations (version) VALUES ('54');

INSERT INTO schema_migrations (version) VALUES ('55');

INSERT INTO schema_migrations (version) VALUES ('56');

INSERT INTO schema_migrations (version) VALUES ('57');

INSERT INTO schema_migrations (version) VALUES ('58');

INSERT INTO schema_migrations (version) VALUES ('59');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('60');

INSERT INTO schema_migrations (version) VALUES ('61');

INSERT INTO schema_migrations (version) VALUES ('62');

INSERT INTO schema_migrations (version) VALUES ('63');

INSERT INTO schema_migrations (version) VALUES ('64');

INSERT INTO schema_migrations (version) VALUES ('65');

INSERT INTO schema_migrations (version) VALUES ('66');

INSERT INTO schema_migrations (version) VALUES ('67');

INSERT INTO schema_migrations (version) VALUES ('68');

INSERT INTO schema_migrations (version) VALUES ('69');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('70');

INSERT INTO schema_migrations (version) VALUES ('71');

INSERT INTO schema_migrations (version) VALUES ('72');

INSERT INTO schema_migrations (version) VALUES ('73');

INSERT INTO schema_migrations (version) VALUES ('74');

INSERT INTO schema_migrations (version) VALUES ('75');

INSERT INTO schema_migrations (version) VALUES ('76');

INSERT INTO schema_migrations (version) VALUES ('77');

INSERT INTO schema_migrations (version) VALUES ('78');

INSERT INTO schema_migrations (version) VALUES ('79');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('80');

INSERT INTO schema_migrations (version) VALUES ('81');

INSERT INTO schema_migrations (version) VALUES ('82');

INSERT INTO schema_migrations (version) VALUES ('83');

INSERT INTO schema_migrations (version) VALUES ('84');

INSERT INTO schema_migrations (version) VALUES ('85');

INSERT INTO schema_migrations (version) VALUES ('86');

INSERT INTO schema_migrations (version) VALUES ('87');

INSERT INTO schema_migrations (version) VALUES ('88');

INSERT INTO schema_migrations (version) VALUES ('89');

INSERT INTO schema_migrations (version) VALUES ('9');

INSERT INTO schema_migrations (version) VALUES ('90');

INSERT INTO schema_migrations (version) VALUES ('91');

INSERT INTO schema_migrations (version) VALUES ('92');

INSERT INTO schema_migrations (version) VALUES ('93');

INSERT INTO schema_migrations (version) VALUES ('94');

INSERT INTO schema_migrations (version) VALUES ('95');

INSERT INTO schema_migrations (version) VALUES ('96');

INSERT INTO schema_migrations (version) VALUES ('97');

INSERT INTO schema_migrations (version) VALUES ('98');

INSERT INTO schema_migrations (version) VALUES ('99');