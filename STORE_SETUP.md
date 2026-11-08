# Shardstrike gem shop — test setup and release handoff

October 17, 2026 · version 0.12.0, build 16

## Current state

The app now has a native gem shop and StoreKit 2 integration. It loads Apple's localized prices, purchases consumables, handles cancellation and pending approval, verifies signed transactions, and retries unfinished deliveries. Paid grants and transaction IDs are written together before StoreKit is told delivery finished. Repeated deliveries cannot mint gems twice. A failed/corrupt wallet save blocks purchases rather than replacing the wallet.

Hero gems are separate from run gems. Hero unlocks spend earned gems first, then bought gems. A paid hero journal recovers an interrupted earned-gem debit once. New Campaign selects Scout and resets earned progress, while bought gems and heroes funded partly or wholly with bought gems remain. Local Xcode, sandbox and production saves are separated.

**This is a test-ready implementation, not a live shop or an App Store submission.** Production purchase buttons remain disabled unless the explicit `ShardstrikeLivePurchasesEnabled` Boolean is enabled in the final app Info.plist. Leave it disabled until the release checks below pass. No app, products, prices or paid agreements were created or submitted in App Store Connect during this change.

Choose an active Apple Developer Program membership and publishing team before registering the final app identity. Membership, agreements, tax and banking setup are completed by the account holder.

## Draft catalog

These amounts and US base prices are proposals, currently used only by the local test configuration. Live pricing needs the owner's decision. Runtime purchase prices always come from Apple, never from these hardcoded proposals.

| Reference/display name | Product ID | Type | Grant | Draft US price |
| --- | --- | --- | --- | --- |
| 100 Hero Gems | `com.shardstrike.herogems.100` | Consumable | 100 hero gems | $0.99 |
| 250 Hero Gems | `com.shardstrike.herogems.250` | Consumable | 250 hero gems | $1.99 |
| 500 Hero Gems | `com.shardstrike.herogems.500` | Consumable | 500 hero gems | $3.99 |

Suggested English descriptions (under 55 characters):

- 100 hero gems to unlock your next hero.
- 250 hero gems to unlock your next favorites.
- 500 hero gems for your growing hero collection.

Product IDs must match the code exactly. Product IDs are not the app's bundle ID; `com.local.gemrush` is still the temporary development bundle ID and must be replaced for the chosen publishing team. No subscriptions, ads, Apple Pay merchant account or credit-card form are involved. Apple handles the App Store purchase sheet and localized currency.

## Free local purchase testing

1. Open `GemRush.xcodeproj` in Xcode.
2. Choose **GemRush Store Testing**, then My Mac or an iPhone simulator.
3. Edit Scheme → Run → Options should show **StoreTesting.storekit**. Run → Arguments includes `SHARDSTRIKE_STORE_TESTING=1`.
4. Run, open Store, and confirm the **Test store · No real charges** label before buying a test pack. This scheme uses separate test campaign and paid-wallet storage.
5. Buy 100 gems, unlock a hero, restart the app, and start a new campaign. Bought gems/paid hero should survive; Scout should be selected.
6. Use Xcode's StoreKit transaction manager to simulate Ask to Buy, cancellation and errors. Pending approval must grant nothing until approved. Cancel must grant nothing. Retry after a delivery failure must grant exactly once.

Use the ordinary **GemRush** scheme for real Apple sandbox/TestFlight work; it has no local StoreKit configuration. Do not upload a local test configuration as a shipping resource.

Automated commands:

```sh
bash test-rules.sh
bash test-store-ledger.sh
bash test-controller.sh
bash test-storekit.sh
```

The first three use isolated test storage. The fourth creates an isolated StoreKitTest session and refuses to buy unless Apple verifies the Xcode environment. Its current terminal run compiled, but could not access `com.apple.storekitagent` because of the tool session's sandbox restriction; **actual checkout, pending approvals, cancellation and transaction finish have not yet passed an end-to-end run**. Run from a normal Xcode/local development test environment. No real transaction was attempted.

## Verification in this build

- 2,957 model/rules/audio assertions passed.
- 1,913 native controller assertions passed, including 15 new paid-wallet integration checks.
- 86 purchase-journal checks passed: duplicate IDs, failed writes, reloads, corrupt storage, concurrent ledger instances, paid hero persistence, invalid quantities and overflow protection.
- Mac and unsigned iPhone Release builds passed. Native Mac shop cards, earned/bought balance, disabled unavailable purchase buttons and saved hero state were inspected.
- StoreKit integration fixture compiled but could not run against Apple's daemon because of the tool sandbox. Its unexecuted checkout assertions are not included in the 4,956 passing total.

## Required before live sales

1. Renew/enroll the chosen Apple Developer team. Select that team in Xcode, register the final bundle identifier, and create the Shardstrike app record. The account holder completes Apple's paid-app agreement, tax forms and payout banking personally. Confirm the chosen gem packs/prices.
2. Add the three consumable products under the app's In-App Purchases section. Enter the table's IDs, localizations, availability and pricing. Upload actual in-app purchase review screenshots showing each pack and its purchase context.
3. Finish purchase recovery before enabling production sales. This build uses a local file, **not a cloud wallet**: uninstall/reinstall, another device, or a lost/corrupt ledger cannot recover finished-consumable balances or the spending history. Add an authenticated server or equivalent conflict-safe cloud ledger with transaction verification and a durable spending journal; test reinstall and multi-device recovery. Do not replay all historic consumables into a blank wallet, because that refunds already-spent gems.
4. Add/test refund reconciliation. This build refuses a refunded transaction presented for delivery, but does not yet claw back an earlier credited/refunded pack. Decide the refund treatment for spent gems and heroes, then implement and test it before live sales.
5. Complete sandbox/TestFlight checkout tests, including interruption after payment, app relaunch, duplicate transaction callbacks, Ask to Buy, restricted payments, network failure, refunds, and price localization. Confirm that test currency never appears in a production install.
6. Complete release assets and metadata: app icon, device screenshots, privacy/support URLs, app privacy answers, age rating, review contact, signed archive and physical iPhone testing. See the release checklist in README.md for remaining game release work.
7. Enable `ShardstrikeLivePurchasesEnabled = YES` only for the reviewed final configuration. Submit the first in-app purchases with the app version. A TestFlight build can test purchases without collecting real revenue; live App Store approval and availability come afterward.

## Apple references checked for this work

- [In-App Purchase overview](https://developer.apple.com/in-app-purchase/)
- [Create consumable products](https://developer.apple.com/help/app-store-connect/manage-in-app-purchases/create-consumable-or-non-consumable-in-app-purchases/)
- [Paid agreements](https://developer.apple.com/help/app-store-connect/manage-agreements/sign-and-update-agreements/)
- [First purchases accompany an app submission](https://developer.apple.com/documentation/appstoreconnectapi/managing-in-app-purchases)
- [TestFlight and distribution membership](https://developer.apple.com/tutorials/develop-in-swift/welcome-to-app-distribution)
- [Free personal-device testing](https://developer.apple.com/help/account/basics/about-your-developer-account)
