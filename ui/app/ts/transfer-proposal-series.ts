/// <amd-module name='transfer-proposal-series'/>


import Vue from "vue";
import VueResource from "vue-resource";
import Utils from "./utils";
// import UI from "./ui";
Vue.use(VueResource);
// import Utils from "./utils";
// import UI from "./ui";

interface SeriesMetadata {
    series_title?:String;
    disposal_class?:String;
    date_range?:String;
    accrual_details?:String;
    creating_agency?:String;
    mandate?:String;
    function?:String;
    system_of_arrangement?:String;
    composition_digital?:Boolean;
    composition_physical?:Boolean;
    composition_hybrid?:Boolean;
}

interface SeriesMetadataState {
    metadata:SeriesMetadata[];
    is_readonly:Boolean;
}

declare var M: any; // Materialize on the window context

Vue.component('transfer-proposal-series', {
    template: `
<div>
    <template v-if="!is_readonly">
        <a class="btn" v-on:click="add">Add Series Metadata</a>
    </template>
    <template v-if="metadata.length > 0">
        <div v-for="(series, index) in metadata" class="card">
            <div class="card-content">
                <div class="row">
                    <div class="input-field col s12">
                        <textarea :id="'series_title_' + index" name="transfer[series][][series_title]" v-model="series.series_title" class="materialize-textarea" required></textarea>
                        <label :for="'series_title_' + index">Series Title</label>
                    </div>
                </div>
                <div class="row">
                    <div class="input-field col s12">
                        <input :id="'disposal_class_' + index" name="transfer[series][][disposal_class]" type="text" v-model="series.disposal_class">
                        <label :for="'disposal_class_' + index">Disposal Class</label>
                    </div>
                </div>
                <div class="row">
                    <div class="input-field col s12">
                        <textarea :id="'date_range_' + index" name="transfer[series][][date_range]" v-model="series.date_range" class="materialize-textarea"></textarea>
                        <label :for="'date_range_' + index">Date Range</label>
                    </div>
                </div>
                <div class="row">
                    <div class="input-field col s12">
                        <textarea :id="'accrual_details_' + index" name="transfer[series][][accrual_details]" v-model="series.accrual_details" class="materialize-textarea"></textarea>
                        <label :for="'accrual_details_' + index">Accrual Details</label>
                    </div>
                </div>
                <div class="row">
                    <div class="input-field col s12">
                        <textarea :id="'creating_agency_' + index" name="transfer[series][][creating_agency]" v-model="series.creating_agency" class="materialize-textarea"></textarea>
                        <label :for="'creating_agency_' + index">Creating Agency</label>
                    </div>
                </div>
                <div class="row">
                    <div class="input-field col s12">
                        <textarea :id="'mandate_' + index" name="transfer[series][][mandate]" v-model="series.mandate" class="materialize-textarea"></textarea>
                        <label :for="'mandate_' + index">Mandate</label>
                    </div>
                </div>
                <div class="row">
                    <div class="input-field col s12">
                        <textarea :id="'function_' + index" name="transfer[series][][function]" v-model="series.function" class="materialize-textarea"></textarea>
                        <label :for="'function_' + index">Function</label>
                    </div>
                </div>
                <div class="row">
                    <div class="input-field col s12">
                        <select name="transfer[series][][system_of_arrangement]" v-model="series.system_of_arrangement">
                            <option disabled></option>
                            <option value="single_number">Single Number</option>
                            <option value="annual_single_number">Annual Single Number</option>
                            <option value="multiple_number">Multiple Number</option>
                            <option value="chronological">Chronological</option>
                            <option value="alphabetical">Alphabetical</option>
                            <option value="unknown">Unknown</option>
                            <option value="other">Other</option>
                        </select>
                        <label>System of Arrangement</label>
                    </div>
                </div>
                <div class="row">
                    <div class="col s12">
                        <label>Composition</label>
                    </div>
                    <div class="col s12">
                        <label>
                            <input type="checkbox" name="transfer[series][][composition_digital]" v-model="series.composition_digital">
                            <span>Digital</span>
                        </label>
                    </div>
                    <div class="col s12">
                        <label>
                            <input type="checkbox" name="transfer[series][][composition_physical]" v-model="series.composition_physical">
                            <span>Physical</span>
                        </label>
                    </div>
                    <div class="col s12">
                        <label>
                            <input type="checkbox" name="transfer[series][][composition_hybrid]" v-model="series.composition_hybrid">
                            <span>Hybrid</span>
                        </label>
                    </div>
                </div>
                <template v-if="!is_readonly">
                    <div class="row">
                        <div class="col s12">
                            <a class="btn right" v-on:click="remove(series)">Remove</a>
                        </div>
                    </div>
                </template>
            </div>
        </div>
    </template>
</div>
`,
    data: function(): SeriesMetadataState {
        return {
            metadata: JSON.parse(this.existing_metadata),
            is_readonly: (this.readonly == 'true'),
        };
    },
    props: ['existing_metadata', 'readonly'],
    methods: {
        add: function() {
            this.metadata.push({});
        },
        remove(toRemove:SeriesMetadata) {
            this.metadata = Utils.filter(this.metadata, (entry:SeriesMetadata) => {
                return entry != toRemove;
            });
        },
    },
    updated: function() {
        M.FormSelect.init(this.$el.querySelectorAll('select'));
    },
    mounted: function() {
        this.$el.querySelectorAll('input,textarea,select').forEach(function(el) {
            if ((<HTMLFormElement>el).value != "") {
                if (el.nextElementSibling) {
                    el.nextElementSibling.classList.add('active');
                }
            }
        });

        if (this.is_readonly) {
            this.$el.querySelectorAll('input,textarea,select').forEach(function(el) {
                (<HTMLFormElement>el).disabled = true;
            });
        }
    }
});