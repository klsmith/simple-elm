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


    send(msg) {
        this.elmApp.ports.localStorageMsgPort.send(msg);
    }


    save({ key, value }) {
        try {
            localStorage.setItem(key, value);
        } catch (err) {
            this.send({
                type: "SaveError",
                message: Json.stringify({ key, value, err })
            });
        }
    }


    load(key) {
        try {
            const value = localStorage.getItem(key);
            this.send({ type: "OnLoad", key, value });
        } catch (err) {
            this.send({
                type: "LoadError",
                message: Json.stringify({ key, err })
            });
        }
    }

}