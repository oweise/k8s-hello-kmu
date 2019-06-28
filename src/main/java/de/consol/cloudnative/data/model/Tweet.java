package de.consol.cloudnative.data.model;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(
        name="tweet",
        indexes={
            @Index(name="tweet_time", columnList = "time", unique = false),
            @Index(name="tweet_author", columnList = "author", unique = false)
        }
)
public class Tweet {

    @Id
    private String id;

    @Column
    @NotNull
    private String author;

    @Column
    @NotNull
    private String body;

    @Column
    private Instant time;

    public Tweet() {
        this.id = UUID.randomUUID().toString();
        this.time = Instant.now();
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public Instant getTime() {
        return time;
    }

    public void setTime(Instant time) {
        this.time = time;
    }
}
