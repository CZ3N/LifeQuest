# Deploy Life Quest to GitHub Pages

The repository includes `.github/workflows/deploy-web.yml`. This workflow can build the Flutter web app and publish it to GitHub Pages after it is pushed to the default `main` branch. A live website is not created by preparing this ZIP alone; it requires the project to be pushed to a public GitHub repository and Pages to be enabled.

## Steps

1. Extract this project and push the contents of the `LifeQuest-main` folder to the root of your public GitHub repository. Make sure `pubspec.yaml`, `lib/`, `web/`, and `.github/workflows/deploy-web.yml` are at the repository root.
2. Open **Settings → Pages** in GitHub. Under **Build and deployment**, choose **GitHub Actions** as the source.
3. Open **Actions** and watch the **Deploy web demo** workflow after pushing to `main`. If it fails, open the failed step and fix the reported issue.
4. When the deployment finishes successfully, open the Pages URL shown by the workflow or in **Settings → Pages**.
5. Test the published site. Check that it loads, that assets load without a blank screen, and that the main screens and interactions work.
6. Copy the exact working URL into the top of `README.md` and submit that live URL for the public-repository final project.

## Important

- A repository URL is not the same as a live website URL.
- Do not submit a guessed URL. Copy the URL shown by GitHub after a successful deployment.
- The app stores data locally in browser preferences. Different browsers/devices do not share the same quest list.
- The workflow runs analysis and tests but is configured not to block deployment when those checks fail. Review their output instead of treating a successful deploy as proof that all tests passed.
