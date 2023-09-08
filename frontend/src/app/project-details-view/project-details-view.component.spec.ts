import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ProjectDetailsViewComponent } from './project-details-view.component';

describe('ProjectDetailsViewComponent', () => {
  let component: ProjectDetailsViewComponent;
  let fixture: ComponentFixture<ProjectDetailsViewComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [ProjectDetailsViewComponent]
    });
    fixture = TestBed.createComponent(ProjectDetailsViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
