class LocalStorage {

    /**
     * Create instance and subscribe to Elm ports.
     */
    constructor(elmApp) {
        this.elmApp = elmApp;
        elmApp.ports.localStorageSavePort.subscribe(
            this.save.bind(this)
        );
        elmApp.ports.localStorageLoadPort.subscribe(
            this.load.bind(this)
        );
    }

    /**
     * Create instance and subscribe to Elm ports.
     */
    static bind(elmApp) {
        return new LocalStorage(elmApp);
    }

    /**
     * Helper method for logging relative to this class.
     */
    log(text = '?', ...data) {
        console.log("LocalStoragePort - " + text, data);
    }

    /**
     * Sends message through port back into Elm.
     */
    send(msg) {
        try {
            this.elmApp.ports.localStorageMsgPort.send(msg);
        } catch (err) {
            log("Failed to send", msg, err);
        }
    }

    /**
     * Saves a value into window.localStorage using provided key.
     * Handles subscription from Elm save port.
     */
    save({ key, value }) {
        try {
            window.localStorage.setItem(key, value);
        } catch (err) {
            log("Failed to save", key, value, err);
        }
    }

    /**
     * Loads a value from window.localStorage using provided key.
     * Handles subscription from Elm save port.
     * Calls this.send(..) with the results.
     */
    load(key) {
        try {
            const value = window.localStorage.getItem(key);
            this.send({ key, value });
        } catch (err) {
            log("Failed to load", key, err);
        }
    }

}