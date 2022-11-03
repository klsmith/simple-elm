class LocalStorage {

    constructor(elmApp) {
        this.elmApp = elmApp;
    }


    static bind(elmApp) {
        const instance = new LocalStorage(elmApp);
        elmApp.ports.localStorageSavePort
            .subscribe(instance.save.bind(instance));
        elmApp.ports.localStorageLoadPort
            .subscribe(instance.load.bind(instance));
        return instance;
    }


    log(text = '?', ...data) {
        console.log("LocalStoragePort - " + text, data);
    }


    send(msg) {
        try {
            this.elmApp.ports.localStorageMsgPort.send(msg);
        } catch (err) {
            log("Failed to send", msg, err);
        }
    }


    save({ key, value }) {
        try {
            window.localStorage.setItem(key, value);
        } catch (err) {
            log("Failed to save", key, value, err);
        }
    }


    load(key) {
        try {
            const value = window.localStorage.getItem(key);
            this.send({ type: "OnLoad", key, value });
        } catch (err) {
            log("Failed to load", key, err);
        }
    }

}