package de.consol.cloudnative.service;

import de.consol.cloudnative.data.dao.TweetRepository;
import de.consol.cloudnative.data.model.Tweet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.util.stream.Stream;

@Service
public class TweetService {

    @Autowired
    private TweetRepository tweetRepository;

    public Page<Tweet> getNewestTweets(Pageable pageable) {
        return tweetRepository.findNewestTweets(pageable);
    }

    public void addNewTweet(Tweet tweet) {
        tweetRepository.save(tweet);
    }

}
