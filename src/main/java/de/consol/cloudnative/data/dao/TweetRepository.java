package de.consol.cloudnative.data.dao;

import de.consol.cloudnative.data.model.Tweet;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Stream;

@Component
public interface TweetRepository extends CrudRepository<Tweet,String> {

    @Query("select t from Tweet t where t.author=:author order by t.time desc")
    Page<Tweet> findByUser(String author, Pageable pageable);

    @Query("select t from Tweet t order by t.time desc")
    Page<Tweet> findNewestTweets(Pageable pageable);

}
