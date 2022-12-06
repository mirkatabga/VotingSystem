class mapDataUtils {
    static mapData(data) {
        return data.map(x => {
            return {
                id: x.Id,
                name: x.User_Id__r.Name,
                role: x.RecordType.Name,
                creatorName: x.CreatedBy.Name
            };
        });
    }

}

export { mapDataUtils };