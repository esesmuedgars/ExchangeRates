## Revolut iOS Test Assignment

### Task

The goal of this assignment is to allow you to demonstrate your programming skills and to allow us to understand your approach when developing a mobile application.

Your app should be production ready - in addition to assessing your code quality, we will be trying to break your app by testing for different usability issues that a real user might encounter. We would like you to implement an exchange rates app. The app must request and update currency rates every second using an API.

API endpoint: https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios.

<table>
    <tr>
        <th>Key</th>
        <th>Type</th>
        <th>Description</th>
    </tr>
        <td>pairs</td>
        <td>Number</td>
        <td>Pair of currency codes to compare rates (e.g. EURUSD - 1 Euro compared to United States dollar).</td>
    </tr>
</table>

```
{
    "EURUSD": 1.1381
}
```

Users should be able to:

- Add a new currency pair;
- Remove a currency pair.

The list of currency pairs should be preserved across application launches.

### Code requirements

- Please use the latest stable Xcode + Swift;
- Avoid use of third-party libraries such as Rx. We would prefer to see a vanilla approach so we can see you understand the underlying concepts. We do use third-party libraries at Revolut of course, but for the purposes of this test, please avoid doing so;
- Please ensure your application has good test coverage.

### Resources

You will find fonts, colors and everything else that may come in handy in Figma [project](https://www.figma.com/file/Vh2zTldjRFFqSk29AmZeVBWy/Exchange-%26-Rates).
UI does not have to be exactly the same, the final implementation is up to you. 

Also, in a zip archive you will find the following:

- A video describing the application flow;
- A list of currencies supported by the test assignment back end;
- An icon.

### What we are looking for:

- Clarity, elegance, and maintainability of code;
- Code consistency. Please refer to a community maintained style guide if you’re unsure;
- A clear architecture and adherence to iOS design patterns;
- Knowledge of the iOS human interface guidelines;
- Appropriate application of relevant native iOS frameworks (Foundation, UIKit);
- Good code coverage with Unit tests.

### What we don’t want to see:

- Overengineered code;
- Lack of Unit testing.

### When you think you're done

We expect to be able to run your code without fuss - so if there are any specifics that are needed to get your code running, please commit them to git repository if possible.
