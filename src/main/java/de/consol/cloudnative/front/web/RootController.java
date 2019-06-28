package de.consol.cloudnative.front.web;

import de.consol.cloudnative.data.model.Tweet;
import de.consol.cloudnative.service.TweetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.view.RedirectView;

import javax.validation.Valid;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Controller
@RequestMapping("/")
public class RootController {

    @Autowired
    private TweetService tweetService;

    @GetMapping
    public String showIndex(final Model model,
                            @RequestParam("page") Optional<Integer> page,
                            @RequestParam("size") Optional<Integer> size) {


        int currentPage = page.orElse(0);
        int pageSize = size.orElse(5);

        Page<Tweet> newestTweets = tweetService.getNewestTweets(
                PageRequest.of(currentPage, pageSize)
        );
        int totalPages = newestTweets.getTotalPages();
        if (totalPages > 0) {
            List<Integer> pageNumbers = IntStream.rangeClosed(1, totalPages)
                    .boxed()
                    .collect(Collectors.toList());
            model.addAttribute("pageNumbers", pageNumbers);
        }

        model.addAttribute("tweets", newestTweets);
        model.addAttribute("detailView", "layouts/tweet-table-layout");
        model.addAttribute("detailSelector", "layout");
        return "index";
    }
}
