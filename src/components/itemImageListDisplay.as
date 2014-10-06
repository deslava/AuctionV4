package components {
import mx.events.FlexEvent;

public class itemImageListDisplay extends itemImageListDisplayLayout {
    public function itemImageListDisplay() {
        super();

        this.addEventListener(FlexEvent.CREATION_COMPLETE, itemImageList_creationComplete)
    }

    protected function itemImageList_creationComplete(event:FlexEvent):void {
        this.useVirtualLayout = false;
        this.dataProvider = null;
    }
}
}